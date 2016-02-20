//
//  iTunesMonitor.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AVFoundation
import RxSwift

class PodcastMonitor {

    var isPodcast: Observable<Bool> {
        return _isPodcast.asObservable()
    }

    var chapterChanged: Observable<Void> {
        return _chapterChanged.asObservable()
    }

    private(set) var chapters: Chapters? {
        didSet {
            contentChanged()
        }
    }
    private(set) var currentChapterIndex: Int? {
        didSet {
            if let index = currentChapterIndex, chapters = chapters {
                let currentItem = chapters.list[index]
                let notification = Notification(description: currentItem.title, image: currentItem.artwork) {
                    PasteBoard.copy(currentItem.title)
                }
                notificationCenter.deliverNotification(notification)

                contentChanged()
            }
        }
    }

    private let _isPodcast = PublishSubject<Bool>()
    private let _chapterChanged = PublishSubject<Void>()
    private let iTunes: iTunesApp
    private let notificationCenter: NotificationCenter
    private let disposeBag = DisposeBag()

    init(iTunes: iTunesApp = iTunesApp(), notificationCenter: NotificationCenter = NotificationCenter.sharedInstance) {
        self.iTunes = iTunes
        self.notificationCenter = notificationCenter

        self.iTunes.playerState
            .subscribeNext { state in
                print("State: \(state)")
            }
            .addDisposableTo(disposeBag)

        self.iTunes.playerPosition
            .subscribeNext { position in
                self.updateCurrentItemForPosition(position)
            }
            .addDisposableTo(disposeBag)

        self.iTunes.nowPlaying
            .subscribeNext { item in
                if case .Podcast(let mediaItem) = item {
                    self._isPodcast.onNext(true)

                    iTunesLibrary.fetchURLForPesistentID(mediaItem.persistentID)
                        .subscribe { event in
                            switch event {
                            case .Next(let URL):
                                Chapters.chaptersFromAsset(AVAsset(URL: URL))
                                    .subscribeNext { chapters in
                                        self.chapters = chapters
                                    }
                                    .addDisposableTo(self.disposeBag)
                            case .Error(let error):
                                print("Error: \(error)")
                            default:
                                print("Default")
                            }
                        }
                        .addDisposableTo(self.disposeBag)
                }
                else {
                    self.resetChapters()
                }
            }
            .addDisposableTo(disposeBag)
    }
}

private extension PodcastMonitor {

    func updateCurrentItemForPosition(position: CDouble) {
        guard let chapters = chapters else {
            return
        }

        if let index = chapters.chapterIndexForPosition(position) {
            if let currentIndex = currentChapterIndex {
                if currentIndex != index {
                    currentChapterIndex = index
                }
            }
            else {
                currentChapterIndex = index
            }
        }
    }

    func resetChapters() {
        chapters = nil
        currentChapterIndex = nil

        _isPodcast.onNext(false)
        contentChanged()
    }

    func contentChanged() {
        _chapterChanged.onNext()
    }
}

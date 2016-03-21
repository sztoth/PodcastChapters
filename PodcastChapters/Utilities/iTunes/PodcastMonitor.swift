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

    var isPlaying: Observable<Bool> {
        return _isPlaying.asObservable()
    }

    var podcastChanged: Observable<Void> {
        return _podcastChanged.asObservable()
    }

    var chapterChanged: Observable<(Int?, Int?)> {
        return _chapterChanged.asObservable()
    }

    private(set) var chapters: Chapters? {
        didSet {
            _chapterChanged.onNext((nil, nil))
        }
    }

    private(set) var currentChapterIndex: Int? {
        didSet {
            _chapterChanged.onNext((oldValue, currentChapterIndex))

            if let index = currentChapterIndex, chapters = chapters {
                let currentItem = chapters.list[index]
                let notification = Notification(description: currentItem.title, image: currentItem.artwork) {
                    self.pasteBoard.copy(currentItem.title)
                }
                notificationCenter.deliverNotification(notification)
            }
        }
    }

    private let _isPodcast = BehaviorSubject<Bool>(value: false)
    private let _isPlaying = BehaviorSubject<Bool>(value: false)
    private let _podcastChanged = PublishSubject<Void>()
    private let _chapterChanged = PublishSubject<(Int?, Int?)>()
    private let iTunes: iTunesApp
    private let notificationCenter: NotificationCenter
    private let pasteBoard: PasteBoard
    private let disposeBag = DisposeBag()

    init(iTunes: iTunesApp = iTunesApp(), notificationCenter: NotificationCenter = NotificationCenter.sharedInstance, pasteBoard: PasteBoard = PasteBoard()) {
        self.iTunes = iTunes
        self.notificationCenter = notificationCenter
        self.pasteBoard = pasteBoard

        self.iTunes.playerState
            .subscribeNext { state in
                switch state {
                case .Playing:
                    self._isPlaying.onNext(true)
                case .Paused:
                    self._isPlaying.onNext(false)
                case .Stopped, .Unknown:
                    self._isPlaying.onNext(false)
                    self.notificationCenter.clearAllNotifications()
                }
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
                    self._podcastChanged.onNext()

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

    func updateCurrentItemForPosition(position: CDouble?) {
        guard let chapters = chapters, position = position else {
            currentChapterIndex = nil
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
        _podcastChanged.onNext()
    }
}

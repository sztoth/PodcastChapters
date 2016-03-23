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

    var chapterChanged: Observable<(Int?, Int?)> {
        return _chapterChanged.asObservable()
    }

    private(set) var chapters: [Chapter]? {
        didSet {
            _chapterChanged.onNext((nil, nil))
        }
    }

    private(set) var currentChapterIndex: Int? {
        didSet {
            if let index = currentChapterIndex, chapters = chapters where oldValue != index {
                _chapterChanged.onNext((oldValue, index))

                let chapter = chapters[index]
                let notification = Notification(description: chapter.title, image: chapter.cover) {
                    self.pasteBoard.copy(chapter.title)
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

                    iTunesLibrary.fetchURLForPesistentID(mediaItem.persistentID)
                        .subscribe { event in
                            if case .Next(let URL) = event {
                                ChapterParser.chaptersFromAsset(AVAsset(URL: URL))
                                    .subscribeNext { chapters in
                                        if let chapters = chapters where 0 < chapters.count {
                                            self.chapters = chapters.map { chapter in
                                                let cover = chapter.artwork != nil ? chapter.artwork : mediaItem.artwork
                                                return Chapter(cover: cover, title: chapter.title, start: chapter.time, duration: chapter.duration)
                                            }
                                        }
                                        else {
                                            let chapter = Chapter(cover: mediaItem.artwork, title: mediaItem.name, start: nil, duration: nil)
                                            self.chapters = [chapter]
                                        }
                                    }
                                    .addDisposableTo(self.disposeBag)
                            }
                            else if case .Error = event {
                                self.reset()
                            }
                        }
                        .addDisposableTo(self.disposeBag)
                }
                else {
                    self.reset()
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

        currentChapterIndex = findChapterIndexForPosition(position, inChapterList: chapters)
    }

    func findChapterIndexForPosition(position: CDouble, inChapterList chapters: [Chapter]) -> Int? {
        for (index, chapter) in chapters.enumerate() {
            if chapter.containsPosition(position) {
                return index
            }
        }

        return nil
    }

    func reset() {
        currentChapterIndex = nil
        chapters = nil

        _isPodcast.onNext(false)
    }
}

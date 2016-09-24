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

    fileprivate(set) var chapters: [Chapter]? {
        didSet {
            _chapterChanged.onNext((nil, nil))
        }
    }

    fileprivate(set) var currentChapterIndex: Int? {
        didSet {
            if let index = currentChapterIndex, let chapters = chapters , oldValue != index {
                _chapterChanged.onNext((oldValue, index))

                let chapter = chapters[index]
                let notification = Notification(description: chapter.title, image: chapter.cover) {
                    self.pasteBoard.copy(chapter.title)
                }
                notificationCenter.deliverNotification(notification)
            }
        }
    }

    fileprivate let _isPodcast = BehaviorSubject<Bool>(value: false)
    fileprivate let _isPlaying = BehaviorSubject<Bool>(value: false)
    fileprivate let _podcastChanged = PublishSubject<Void>()
    fileprivate let _chapterChanged = PublishSubject<(Int?, Int?)>()
    fileprivate let iTunes: iTunesApp
    fileprivate let notificationCenter: NotificationCenter
    fileprivate let pasteBoard: PasteBoard
    fileprivate let disposeBag = DisposeBag()

    init(iTunes: iTunesApp = iTunesApp(), notificationCenter: NotificationCenter = NotificationCenter.sharedInstance, pasteBoard: PasteBoard = PasteBoard()) {
        self.iTunes = iTunes
        self.notificationCenter = notificationCenter
        self.pasteBoard = pasteBoard

        self.iTunes.playerState
            .subscribe(onNext: { state in
                switch state {
                case .Playing:
                    self._isPlaying.onNext(true)
                case .Paused:
                    self._isPlaying.onNext(false)
                case .Stopped, .Unknown:
                    self._isPlaying.onNext(false)
                    self.notificationCenter.clearAllNotifications()
                }
            })
            .addDisposableTo(disposeBag)

        self.iTunes.playerPosition
            .subscribe(onNext: { position in
                self.updateCurrentItemForPosition(position)
            })
            .addDisposableTo(disposeBag)

        // TODO:
//        self.iTunes.nowPlaying
//            .subscribe(onNext: { item in
//                if case .podcast(let mediaItem) = item {
//                    self._isPodcast.onNext(true)
//
//                    iTunesLibrary.fetchURLForPesistentID(mediaItem.persistentID)
//                        .subscribe { event in
//                            if case .next(let URL) = event {
//                                ChapterParser.chaptersFromAsset(AVAsset(url: URL))
//                                    .subscribe { chapters in
//                                        if let chapters = chapters , 0 < chapters.count {
//                                            self.chapters = chapters.map { chapter in
//                                                let cover = chapter.artwork != nil ? chapter.artwork : mediaItem.artwork
//                                                return Chapter(cover: cover, title: chapter.title, start: chapter.time, duration: chapter.duration)
//                                            }
//                                        }
//                                        else {
//                                            let chapter = Chapter(cover: mediaItem.artwork, title: mediaItem.name, start: nil, duration: nil)
//                                            self.chapters = [chapter]
//                                        }
//                                    }
//                                    .addDisposableTo(self.disposeBag)
//                            }
//                            else if case .Error = event {
//                                self.reset()
//                            }
//                        }
//                        .addDisposableTo(self.disposeBag)
//                }
//                else {
//                    self.reset()
//                }
//            })
//            .addDisposableTo(disposeBag)
    }
}

private extension PodcastMonitor {

    func updateCurrentItemForPosition(_ position: CDouble?) {
        guard let chapters = chapters, let position = position else {
            currentChapterIndex = nil
            return
        }

        currentChapterIndex = findChapterIndexForPosition(position, inChapterList: chapters)
    }

    func findChapterIndexForPosition(_ position: CDouble, inChapterList chapters: [Chapter]) -> Int? {
        for (index, chapter) in chapters.enumerated() {
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

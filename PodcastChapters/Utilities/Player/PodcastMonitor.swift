//
//  iTunesMonitor.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import AVFoundation
import RxOptional
import RxSwift

class PodcastMonitor {
    var podcast: Observable<Bool> {
        return itunes.nowPlaying.map({ $0?.isPodcast ?? false })
    }
    var playing: Observable<Bool> {
        return itunes.playerState.map({ $0 == .playing ? true : false })
    }
    var chapters: Observable<[Chapter]?> {
        return _chapters.asObservable()
    }
    var playingChapterIndex: Observable<Int?> {
        return _playingChapterIndex.asObservable().distinctUntilChanged()
    }

    fileprivate let _chapters = Variable<[Chapter]?>(nil)
    fileprivate let _playingChapterIndex = Variable<Int?>(nil)
    fileprivate let itunes: iTunes
    fileprivate let mediaLoader: MediaLoader
    fileprivate let notificationCenter: NotificationCenter
    fileprivate let pasteBoard: PasteBoard
    fileprivate let disposeBag = DisposeBag()

    init(
        itunes: iTunes = iTunes(),
        mediaLoader: MediaLoader,
        notificationCenter: NotificationCenter = NotificationCenter.sharedInstance,
        pasteBoard: PasteBoard = PasteBoard()
    ) {
        self.itunes = itunes
        self.mediaLoader = mediaLoader
        self.notificationCenter = notificationCenter
        self.pasteBoard = pasteBoard

        setupBindings()
    }
}

fileprivate extension PodcastMonitor {
    func setupBindings() {
        itunes.nowPlaying
            .distinctUntilChanged()
            .mapToVoid()
            .debug("PodcastMonitor | track changed")
            .subscribe(onNext: self.reset)
            .addDisposableTo(disposeBag)

        itunes.playerState
            .filter({ $0 == .stopped || $0 == .unknown})
            .mapToVoid()
            .debug("PodcastMonitor | clear notifications")
            .subscribe(onNext: (self.notificationCenter.clearAllNotifications))
            .addDisposableTo(disposeBag)

        let podcastItemSignal = itunes.nowPlaying
            .filterNil()
            .filter({ $0.isPodcast == true })
            .debug("PodcastMonitor | is podcast")

        let chaptersSignal = podcastItemSignal
            .map({ $0.identifier })
            .flatMap(mediaLoader.URLFor)
            .map({ AVAsset(url: $0) })
            .flatMap(ChapterLoader.chaptersFrom)
            .debug("PodcastMonitor | podcast processing")
            .catchError({ _ in
                self.reset()
                return Observable.empty()
            })

        let processedChapterSignal = Observable.zip(
            podcastItemSignal,
            chaptersSignal,
            resultSelector: processChapterWithDefaultArtwork
        )
        processedChapterSignal
            .map({ Optional($0) })
            .debug("PodcastMonitor | chapters loaded")
            .bindTo(_chapters)
            .addDisposableTo(disposeBag)

        itunes.playerPosition
            .map(findCurrentChapterIndex(forPosition:))
            .bindTo(_playingChapterIndex)
            .addDisposableTo(disposeBag)

        playingChapterIndex
            .filterNil()
            .map { self._chapters.value?[$0] }
            .filterNil()
            .debug("PodcastMonitor | send notification")
            .subscribe(onNext: sendNotification(withChapter:))
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Reactive processing functions

fileprivate extension PodcastMonitor {
    func reset() {
        _chapters.value = nil
        _playingChapterIndex.value = nil
    }

    func processChapterWithDefaultArtwork(_ input: (track: iTunesTrackWrapper, chapters: [MNAVChapter]?)) -> [Chapter] {
        guard let chapters = input.chapters, !chapters.isEmpty else {
            return [Chapter(cover: input.track.artwork, title: input.track.title, start: nil, duration: nil)]
        }

        return chapters.map { chapter in
            let cover = chapter.artwork != nil ? chapter.artwork : input.track.artwork
            return Chapter(cover: cover, title: chapter.title, start: chapter.time, duration: chapter.duration)
        }
    }

    func findCurrentChapterIndex(forPosition position: Double?) -> Int? {
        guard let chapters = _chapters.value, let position = position else { return nil }

        for (index, chapter) in chapters.enumerated() {
            if chapter.contains(position) {
                return index
            }
        }

        return nil
    }

    func sendNotification(withChapter chapter: Chapter) {
        let notification = Notification(description: chapter.title, image: chapter.cover) {
            self.pasteBoard.copy(chapter.title)
        }
        notificationCenter.deliverNotification(notification)
    }
}

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

protocol PodcastMonitorType {
    var podcast: Observable<Bool> { get }
    var playing: Observable<Bool> { get }
    var chapters: Observable<[Chapter]?> { get }
    var playingChapterIndex: Observable<Int?> { get }
}

class PodcastMonitor: PodcastMonitorType {
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
    fileprivate let itunes: iTunesType
    fileprivate let pasteBoard: PasteBoardType
    fileprivate let mediaLoader: MediaLoaderType
    fileprivate let appNotificationCenter: AppNotificationCenterType
    fileprivate let disposeBag = DisposeBag()

    init(
        itunes: iTunesType = iTunes(),
        pasteBoard: PasteBoardType = PasteBoard(),
        mediaLoader: MediaLoaderType,
        appNotificationCenter: AppNotificationCenterType
    ) {
        self.itunes = itunes
        self.pasteBoard = pasteBoard
        self.mediaLoader = mediaLoader
        self.appNotificationCenter = appNotificationCenter

        setupBindings()
    }
}

// MARK: - Setup

fileprivate extension PodcastMonitor {
    func setupBindings() {
        itunes.nowPlaying
            .mapToVoid()
            .debug("PodcastMonitor | track changed")
            .subscribe(onNext: self.reset)
            .addDisposableTo(disposeBag)

        itunes.playerState
            .filter({ $0 == .stopped || $0 == .unknown})
            .mapToVoid()
            .debug("PodcastMonitor | clear notifications")
            .subscribe(onNext: (self.appNotificationCenter.clearAllNotifications))
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

// MARK: - RxSwift methods

fileprivate extension PodcastMonitor {
    func reset() {
        _chapters.value = nil
        _playingChapterIndex.value = nil
    }

    func processChapterWithDefaultArtwork(_ input: (track: iTunesTrackWrapperType, chapters: [MNAVChapter]?)) -> [Chapter] {
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
        let appNotification = AppNotification(description: chapter.title, image: chapter.cover) {
            self.pasteBoard.copy(chapter.title)
        }
        appNotificationCenter.deliver(appNotification)
    }
}

//
//  ChaptersViewModel.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import RxCocoa
import RxSwift

class ChaptersViewModel {
    var artwork: Driver<NSImage?> {
        return _artwork.asDriver()
    }
    var title: Driver<String?> {
        return _title.asDriver()
    }
    var playing: Driver<Bool> {
        return podcastMonitor.playing.asDriver(onErrorJustReturn: false)
    }
    var chapterChanged: Driver<(Int?, Int?)> {
        return _chapterChanged.asDriver(onErrorJustReturn: (nil, nil))
    }

    fileprivate let _artwork = Variable<NSImage?>(nil)
    fileprivate let _title = Variable<String?>(nil)
    fileprivate let _chapterChanged = PublishSubject<(Int?, Int?)>()
    fileprivate let chapters = Variable<[Chapter]?>(nil)
    fileprivate let currentChapterIndex = Variable<Int?>(nil)
    fileprivate let disposeBag = DisposeBag()
    fileprivate let podcastMonitor: PodcastMonitorType
    fileprivate let pasteBoard: PasteBoardType

    init(podcastMonitor: PodcastMonitorType, pasteBoard: PasteBoardType = PasteBoard()) {
        self.podcastMonitor = podcastMonitor
        self.pasteBoard = pasteBoard

        setupBindings()
    }
}

fileprivate extension ChaptersViewModel {
    func setupBindings() {
        podcastMonitor.chapters
            .bindTo(chapters)
            .addDisposableTo(disposeBag)

        podcastMonitor.playingChapterIndex
            .bindTo(currentChapterIndex)
            .addDisposableTo(disposeBag)

        let defaultValue: [Int?] = [nil]
        podcastMonitor.playingChapterIndex
            .scan(defaultValue, accumulator: { (previous, current) in
                return Array(Array(previous + [current]).suffix(2))
            })
            .map({ ($0[0], $0[1]) })
            .bindTo(_chapterChanged)
            .addDisposableTo(disposeBag)

        let currentChapter = Observable.combineLatest(
            chapters.asObservable(),
            podcastMonitor.playingChapterIndex) { (chapters, index) -> Chapter? in
                guard let chapters = chapters, let index = index else { return nil }
                return chapters[index]
            }

        currentChapter
            .map { $0?.cover }
            .bindTo(_artwork)
            .addDisposableTo(disposeBag)

        currentChapter
            .map { $0?.title }
            .bindTo(_title)
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Comment
extension ChaptersViewModel {
    func copyCurrentChapterTitleToClipboard() {
        guard let title = _title.value else { return }
        pasteBoard.copy(title)
    }
}

extension ChaptersViewModel {
    func numberOfChapters() -> Int {
        return chapters.value?.count ?? 0
    }

    func chapterData(for index: Int) -> (String, Bool)? {
        guard let chapter = chapters.value?[index], let currentIndex = currentChapterIndex.value else { return nil }
        return (chapter.title, currentIndex == index)
    }
}

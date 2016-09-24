//
//  ChaptersViewModel.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation
import RxSwift

typealias ChapterData = (title: String, playing: Bool)

class ChaptersViewModel {

    var artwork = Variable<NSImage?>(nil)
    var title = Variable<String>("This is the title")

    var isPlaying: Observable<Bool> {
        return podcastMonitor.isPlaying
    }

    var chapterChanged: Observable<(Int?, Int?)> {
        return podcastMonitor.chapterChanged
    }

    fileprivate let podcastMonitor: PodcastMonitor
    fileprivate let pasteBoard: PasteBoard
    fileprivate let disposeBag = DisposeBag()

    init(podcastMonitor: PodcastMonitor = PodcastMonitor(), pasteBoard: PasteBoard = PasteBoard()) {
        self.podcastMonitor = podcastMonitor
        self.pasteBoard = pasteBoard

        self.podcastMonitor.chapterChanged
            .subscribe { [unowned self] _ in
                if let chapters = self.podcastMonitor.chapters, let index = self.podcastMonitor.currentChapterIndex {
                    let chapter = chapters[index]
                    self.artwork.value = chapter.cover
                    self.title.value = chapter.title
                }
            }
            .addDisposableTo(disposeBag)
    }
}

extension ChaptersViewModel {

    func copyCurrentChapterTitleToClipboard() {
        pasteBoard.copy(title.value)
    }
}

extension ChaptersViewModel {

    func numberOfChapters() -> Int {
        return podcastMonitor.chapters?.count ?? 0
    }

    func chapterDataForIndex(_ index: Int) -> ChapterData? {
        if let chapters = podcastMonitor.chapters {
            let chapter = chapters[index]

            var selected = false
            if let currentChapterIndex = podcastMonitor.currentChapterIndex {
                selected = (index == currentChapterIndex)
            }

            return (chapter.title, selected)
        }

        return nil
    }
}

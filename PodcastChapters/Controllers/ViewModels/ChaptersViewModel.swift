//
//  ChaptersViewModel.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

typealias ChapterData = (title: String, playing: Bool)

class ChaptersViewModel {

    var artwork = Variable<NSImage?>(nil)
    var title = Variable<String>("This is the title")

    var isPlaying: Observable<Bool> {
        return podcastMonitor.isPlaying
    }

    var podcastChanged: Observable<Void> {
        return podcastMonitor.podcastChanged
    }

    var chapterChanged: Observable<(Int?, Int?)> {
        return podcastMonitor.chapterChanged
    }

    private let podcastMonitor: PodcastMonitor
    private let disposeBag = DisposeBag()

    init(podcastMonitor: PodcastMonitor = PodcastMonitor()) {
        self.podcastMonitor = podcastMonitor

        self.podcastMonitor.chapterChanged
            .subscribeNext { [unowned self] _ in
                if let chapters = self.podcastMonitor.chapters, index = self.podcastMonitor.currentChapterIndex {
                    let chapter = chapters.list[index]
                    self.artwork.value = chapter.artwork
                    self.title.value = chapter.title
                }
            }
            .addDisposableTo(disposeBag)
    }
}

extension ChaptersViewModel {

    func copyCurrentChapterTitleToClipboard() {
        PasteBoard.copy(title.value)
    }
}

extension ChaptersViewModel {

    func numberOfChapters() -> Int {
        return podcastMonitor.chapters?.list.count ?? 0
    }

    func chapterDataForIndex(index: Int) -> ChapterData? {
        if let chapters = podcastMonitor.chapters {
            let chapter = chapters.list[index]

            var selected = false
            if let currentChapterIndex = podcastMonitor.currentChapterIndex {
                selected = (index == currentChapterIndex)
            }

            return (chapter.title, selected)
        }

        return nil
    }
}
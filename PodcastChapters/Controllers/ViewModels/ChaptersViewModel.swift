//
//  ChaptersViewModel.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

typealias ChapterData = (String, Bool)

class ChaptersViewModel {

    var chapterChanged: Observable<Void> {
        return podcastMonitor.chapterChanged
    }

    private let podcastMonitor: PodcastMonitor

    init(podcastMonitor: PodcastMonitor = PodcastMonitor()) {
        self.podcastMonitor = podcastMonitor
    }
}

extension ChaptersViewModel {

    func numberOfChapters() -> Int {
        return podcastMonitor.chapters?.list.count ?? 0
    }

    func chapterDataForIndex(index: Int) -> ChapterData? {
        if let chapters = podcastMonitor.chapters {
            let chapter = chapters.list[index]

            return (chapter.title, false)
        }

        return nil
    }
}
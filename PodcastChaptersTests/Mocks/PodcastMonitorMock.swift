//
//  PodcastMonitorMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift
@testable
import PodcastChapters

class PodcastMonitorMock: PodcastMonitorType {
    var podcast: Observable<Bool> {
        return podcastSignal.asObservable()
    }
    var playing: Observable<Bool> {
        return playingSignal.asObservable()
    }
    var chapters: Observable<[Chapter]?> {
        return chaptersSignal.asObservable()
    }
    var playingChapterIndex: Observable<Int?> {
        return playingChapterIndexSignal.asObservable()
    }

    let podcastSignal = PublishSubject<Bool>()
    let playingSignal = PublishSubject<Bool>()
    let chaptersSignal = PublishSubject<[Chapter]?>()
    let playingChapterIndexSignal = PublishSubject<Int?>()
}

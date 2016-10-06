//
//  PodcastMonitorMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

@testable import PodcastChapters

class PodcastMonitorMock: PodcastMonitor {
    override var podcast: Observable<Bool> {
        return podcastSignal.asObservable()
    }
    override var playing: Observable<Bool> {
        return playingSignal.asObservable()
    }
    override var chapters: Observable<[Chapter]?> {
        return chaptersSignal.asObservable()
    }
    override var playingChapterIndex: Observable<Int?> {
        return playingChapterIndexSignal.asObservable()
    }

    let podcastSignal = BehaviorSubject<Bool>(value: false)
    let playingSignal = BehaviorSubject<Bool>(value: false)
    let chaptersSignal = PublishSubject<[Chapter]?>()
    let playingChapterIndexSignal = PublishSubject<Int?>()
}

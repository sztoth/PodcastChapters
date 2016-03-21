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

    override var isPodcast: Observable<Bool> {
        return isPodcastSignal.asObservable()
    }

    override var isPlaying: Observable<Bool> {
        return isPodcastSignal.asObservable()
    }

    override var podcastChanged: Observable<Void> {
        return podcastChangedSignal.asObservable()
    }

    override var chapterChanged: Observable<(Int?, Int?)> {
        return chapterChangedSignal.asObservable()
    }

    let isPodcastSignal = BehaviorSubject<Bool>(value: false)
    let isPlayingSignal = BehaviorSubject<Bool>(value: false)
    let podcastChangedSignal = PublishSubject<Void>()
    let chapterChangedSignal = PublishSubject<(Int?, Int?)>()
}
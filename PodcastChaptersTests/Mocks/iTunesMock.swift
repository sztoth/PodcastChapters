//
//  iTunesMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

@testable import PodcastChapters

class iTunesMock: iTunesType {
    var playerState: Observable<PlayerState> {
        return playerStateSignal.asObservable()
    }
    var playerPosition: Observable<Double?> {
        return playerPositionSignal.asObservable()
    }
    var nowPlaying: Observable<iTunesTrackWrapperType?> {
        return nowPlayingSignal.asObservable()
    }

    let playerStateSignal = PublishSubject<PlayerState>()
    let playerPositionSignal = PublishSubject<Double?>()
    let nowPlayingSignal = PublishSubject<iTunesTrackWrapperType?>()
}

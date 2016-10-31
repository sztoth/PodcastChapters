//
//  iTuneApplicationWrapperMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
@testable
import PodcastChapters

class iTunesApplicationWrapperMock: NSObject {
    var playerStateMock = PlayerState.unknown
    var playerPositionMock = 0.0
    var currentTrackMock: iTunesTrackWrapperMock?
}

extension iTunesApplicationWrapperMock: iTunesApplicationWrapperType {
    var playerState: PlayerState {
        return playerStateMock
    }
    var playerPosition: Double {
        return playerPositionMock
    }
    var currentTrack: iTunesTrackWrapperType? {
        return currentTrackMock
    }
}

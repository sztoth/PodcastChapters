//
//  iTuneApplicationWrapperMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class iTunesApplicationWrapperMock: NSObject {
    var playerStateMock = PlayerState.stopped
    var playerPositionMock = 0.0
    var currentTrackMock: iTunesTrackWrapperMock?
}

extension iTunesApplicationWrapperMock: iTunesApplicationWrapperType {
    var playerState: PlayerState {
        return .playing
    }
    var playerPosition: Double {
        return 0.0
    }
    var currentTrack: iTunesTrackWrapperType? {
        return currentTrackMock
    }
}

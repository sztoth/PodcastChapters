//
//  iTunesApplicationWrapperTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class iTunesApplicationWrapperTests: XCTestCase {
    var sut: iTunesApplicationWrapper!

    fileprivate let itunesApplication = iTunesApplicationMock()

    override func setUp() {
        super.setUp()

        sut = iTunesApplicationWrapper(itunesApplication: itunesApplication)
    }
}

// MARK: - PlayerState

extension iTunesApplicationWrapperTests {
    func test_PlayerStateIsConverted() {
        let statePairs: [(iTunesEPlS, PlayerState)] = [
            (iTunesEPlSPlaying, .playing),
            (iTunesEPlSPaused, .paused),
            (iTunesEPlSStopped, .stopped),
            (iTunesEPlSRewinding, .unknown),
            (iTunesEPlSFastForwarding, .unknown)
        ]

        statePairs.forEach { pair in
            itunesApplication.mockPlayerState = pair.0
            XCTAssertEqual(sut.playerState, pair.1)
        }
    }
}

// MARK: - PlayerPosition

extension iTunesApplicationWrapperTests {
    func test_PlayerPositionIsReturned() {
        let positions = [0.0, 100.0, 0.5, 456.0345]

        positions.forEach { position in
            itunesApplication.mockPlayerPosition = position
            XCTAssertEqual(sut.playerPosition, position)
        }
    }
}

// MARK: - CurrentTrack

extension iTunesApplicationWrapperTests {
    func test_CurrentTrackHasCorrectData() {

    }
}

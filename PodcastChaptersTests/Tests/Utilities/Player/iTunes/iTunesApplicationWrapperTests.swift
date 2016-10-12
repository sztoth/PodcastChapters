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
        let image = NSImage.pch_loadImage(named: "test_artwork")
        let track = testTrack(artwork: [image])
        itunesApplication.mockCurrentTrack = track

        guard let currentTrack = sut.currentTrack else {
            XCTFail("The current track is nil")
            return
        }

        XCTAssertEqual(currentTrack.identifier, track.persistentID)
        XCTAssertEqual(currentTrack.artist, track.artist)
        XCTAssertTrue(currentTrack.isPodcast)
        XCTAssertEqual(currentTrack.identifier, track.persistentID)
        XCTAssertEqual(currentTrack.artwork!, image)
    }

    func test_FailsIfTheIdentifierOrArtistOrTitleIsMissing() {
        let tracks = [
            testTrack(withIdentifier: nil),
            testTrack(artist: nil),
            testTrack(title: nil)
        ]

        tracks.forEach { track in
            itunesApplication.mockCurrentTrack = track
            XCTAssertNil(sut.currentTrack)
        }
    }
}

// MARK: - Helper

fileprivate extension iTunesApplicationWrapperTests {
    func testTrack(
        withIdentifier identifier: String? = "identifier",
        artist: String? = "DJ Berenies",
        title: String? = "Turn it up",
        mediaKind: iTunesEMdK = iTunesEMdKPodcast,
        artwork: [NSImage]? = nil) -> iTunesTrackMock
    {
        return iTunesTrackMock(
            mockPersistentID: identifier,
            mockArtist: artist,
            mockTitle: title,
            mockMediaKind: mediaKind,
            mockArtwork: artwork)
    }
}

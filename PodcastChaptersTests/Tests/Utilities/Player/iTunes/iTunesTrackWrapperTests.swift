//
//  iTunesTrackWrapperTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest
@testable
import PodcastChapters

class iTunesTrackWrapperTests: XCTestCase {
    fileprivate var sut: iTunesTrackWrapper!

    override func setUp() {
        super.setUp()

        sut = testTrack()
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
    }
}

// MARK: - Tracks are equal tests

extension iTunesTrackWrapperTests {
    func test_TracksAreEqual() {
        let track = testTrack()
        XCTAssertEqual(sut, track)
    }

    func test_EqualToItself() {
        XCTAssertEqual(sut, sut)
    }
}

// MARK: - Tracks different tests

extension iTunesTrackWrapperTests {
    func test_TracksAreDifferent() {
        let track = testTrack(withIdentifier: "fake identifier")
        XCTAssertNotEqual(sut, track)
    }

    func test_NotEqualToNil() {
        XCTAssertNotEqual(sut, nil)
    }

    func test_NotEqualToADifferentTypeOfObject() {
        XCTAssertFalse(sut.isEqual("nope"))
    }
}

// MARK: - Helper

fileprivate extension iTunesTrackWrapperTests {
    func testTrack(withIdentifier identifier: String = "identifier") -> iTunesTrackWrapper {
        return iTunesTrackWrapper(
            identifier: identifier,
            artwork: nil,
            artist: "DJ Test",
            title: "Run this sh*t",
            podcast: true
        )
    }
}

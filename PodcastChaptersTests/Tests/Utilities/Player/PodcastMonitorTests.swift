//
//  PodcastMonitorTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest
@testable
import PodcastChapters

class PodcastMonitorTests: XCTestCase {
    fileprivate var sut: PodcastMonitor!
    fileprivate var itunes: iTunesMock!
    fileprivate var pasteBoard: PasteBoardMock!
    fileprivate var mediaLoader: MediaLoaderMock!
    fileprivate var appNotificationCenter: AppNotificationCenterMock!

    override func setUp() {
        super.setUp()

        itunes = iTunesMock()
        pasteBoard = PasteBoardMock()
        mediaLoader = MediaLoaderMock()
        appNotificationCenter = AppNotificationCenterMock()

        sut = PodcastMonitor(
            itunes: itunes,
            pasteBoard: pasteBoard,
            mediaLoader: mediaLoader,
            appNotificationCenter: appNotificationCenter
        )
    }

    override func tearDown() {
        super.tearDown()

        itunes = nil
        pasteBoard = nil
        mediaLoader = nil
        appNotificationCenter = nil
        sut = nil
    }
}

// MARK: - Podcast type related tests

extension PodcastMonitorTests {
    func test_Example() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

//
//  PodcastMonitorTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class PodcastMonitorTests: XCTestCase {
    var sut: PodcastMonitor!

    fileprivate let itunes = iTunesMock()
    fileprivate let pasteBoard = PasteBoardMock()
    fileprivate let mediaLoader = MediaLoaderMock()
    fileprivate let notificationCenter = NotificationCenterMock()

    override func setUp() {
        super.setUp()

        sut = PodcastMonitor(
            itunes: itunes,
            pasteBoard: pasteBoard,
            mediaLoader: mediaLoader,
            notificationCenter: notificationCenter
        )
    }
}

// MARK: - Podcast type related tests

extension PodcastMonitorTests {
    func test_Example() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

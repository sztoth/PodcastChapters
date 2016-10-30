//
//  ContentCoordinatorTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class ContentCoordinatorTests: XCTestCase {
    fileprivate var sut: ContentCoordinator!
    fileprivate var popover: Popover!
    fileprivate var podcastMonitor: PodcastMonitorMock!

    override func setUp() {
        super.setUp()

        popover = Popover()
        podcastMonitor = PodcastMonitorMock()
        sut = ContentCoordinator(popover: popover, podcastMonitor: podcastMonitor)
    }

    override func tearDown() {
        super.tearDown()

        popover = nil
        podcastMonitor = nil
        sut = nil
    }
}

// MARK: - Content testing

extension ContentCoordinatorTests {
    func test_ContentIsChaptersView() {
        podcastMonitor.podcastSignal.onNext(true)

        XCTAssertTrue(popover.content is ChaptersViewController)
    }

    func test_ContentIsOtherView() {
        podcastMonitor.podcastSignal.onNext(false)

        XCTAssertTrue(popover.content is OtherContentViewController)
    }
}

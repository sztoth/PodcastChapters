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

    var contentCoordinator: ContentCoordinator!
    var popover: Popover!
    var podcastMonitor: PodcastMonitorMock!

    override func setUp() {
        super.setUp()

        popover = Popover()
        podcastMonitor = PodcastMonitorMock()
        contentCoordinator = ContentCoordinator(popover: popover, podcastMonitor: podcastMonitor)
    }

    func test_ContentIsChaptersView() {
        podcastMonitor.podcastSignal.onNext(true)

        XCTAssert(popover.content is ChaptersViewController)
    }

    func test_ContentIsOtherView() {
        podcastMonitor.podcastSignal.onNext(false)

        XCTAssert(popover.content is OtherContentViewController)
    }
}

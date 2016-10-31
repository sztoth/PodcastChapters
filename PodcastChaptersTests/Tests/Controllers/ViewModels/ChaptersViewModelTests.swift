//
//  ChaptersViewModelTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest
@testable
import PodcastChapters

class ChaptersViewModelTests: XCTestCase {
    fileprivate var sut: ChaptersViewModel!
    fileprivate var podcastMonitor: PodcastMonitorMock!

    override func setUp() {
        super.setUp()

        podcastMonitor = PodcastMonitorMock()
        sut = ChaptersViewModel(podcastMonitor: podcastMonitor)
    }

    override func tearDown() {
        super.tearDown()

        podcastMonitor = nil
        sut = nil
    }
}

extension ChaptersViewModelTests {
    func test_ObservablesGivingProperValues() {

    }
}

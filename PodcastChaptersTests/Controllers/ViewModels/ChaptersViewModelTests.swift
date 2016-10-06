//
//  ChaptersViewModelTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class ChaptersViewModelTests: XCTestCase {
    var chaptersViewModel: ChaptersViewModel!
    var podcastMonitor: PodcastMonitorMock!

    override func setUp() {
        super.setUp()

        podcastMonitor = PodcastMonitorMock(mediaLoader: MediaLoaderMock())
        chaptersViewModel = ChaptersViewModel(podcastMonitor: podcastMonitor)
    }

    func testObservablesGivingProperValues() {
        
    }
}

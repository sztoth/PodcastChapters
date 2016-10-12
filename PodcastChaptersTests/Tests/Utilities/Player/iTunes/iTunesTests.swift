//
//  iTunesTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class iTunesTests: XCTestCase {
    var sut: iTunes!

    let itunesApplicationWrapper = iTunesApplicationWrapperMock()
    let notificationCenter = DistributedNotificationCenterMock()

    override func setUp() {
        super.setUp()

        sut = iTunes(
            itunesApplication: itunesApplicationWrapper,
            notificationCenter: notificationCenter
        )
    }
}

extension iTunesTests {
}

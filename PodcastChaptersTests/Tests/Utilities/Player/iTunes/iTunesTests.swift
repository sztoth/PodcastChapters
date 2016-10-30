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
    fileprivate var sut: iTunes!
    fileprivate var itunesApplicationWrapper: iTunesApplicationWrapperMock!
    fileprivate var notificationCenter: DistributedNotificationCenterMock!

    override func setUp() {
        super.setUp()

        itunesApplicationWrapper = iTunesApplicationWrapperMock()
        notificationCenter = DistributedNotificationCenterMock()

        sut = iTunes(
            itunesApplication: itunesApplicationWrapper,
            notificationCenter: notificationCenter
        )
    }

    override func tearDown() {
        super.tearDown()

        itunesApplicationWrapper = nil
        notificationCenter = nil
        sut = nil
    }
}

extension iTunesTests {
}

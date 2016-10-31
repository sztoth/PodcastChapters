//
//  iTunesTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxTest
import RxSwift
import XCTest
@testable
import PodcastChapters

class iTunesTests: XCTestCase {
    fileprivate var sut: iTunes!
    fileprivate var itunesApplicationWrapper: iTunesApplicationWrapperMock!
    fileprivate var notificationCenter: DistributedNotificationCenterMock!
    fileprivate var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        itunesApplicationWrapper = iTunesApplicationWrapperMock()
        notificationCenter = DistributedNotificationCenterMock()
        disposeBag = DisposeBag()

        sut = iTunes(
            itunesApplication: itunesApplicationWrapper,
            notificationCenter: notificationCenter
        )
    }

    override func tearDown() {
        super.tearDown()

        itunesApplicationWrapper = nil
        notificationCenter = nil
        disposeBag = nil
        sut = nil
    }
}

// MARK: - Setup testing

extension iTunesTests {
    func test_AddsObserver() {
        XCTAssertEqual(notificationCenter.notificationName!, "com.apple.iTunes.playerInfo")
    }
}

// MARK: - iTunes info processing tests

extension iTunesTests {
    func test_PlayerStateIsUpdating() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(PlayerState.self)

        sut.playerState
            .subscribe(observer)
            .addDisposableTo(disposeBag)

        let pairs: [(Int, PlayerState)] = [(10, .playing), (20, .paused), (30, .stopped)]
        pairs.forEach { pair in
            scheduler.scheduleAt(pair.0) {
                self.itunesApplicationWrapper.playerStateMock = pair.1
                self.notificationCenter.notificationBlock!(Notification(name: Notification.Name("")))
            }
        }

        scheduler.start()

        XCTAssertEqual(observer.events, [.next(.unknown), .next(.playing), .next(.paused), .next(.stopped)])
    }

    // This test is a bit hacky but I could not come up with a better solution
    // to test a feature which uses a timer.
    func test_PositionIsUpdating() {
        let exp = expectation(description: "position is updating")

        let testValues = [0.0, 1.5, 5.2, 10.0, 56.56]
        var positions = [Double]()
        var index = 1

        itunesApplicationWrapper.playerStateMock = .playing
        notificationCenter.notificationBlock!(Notification(name: Notification.Name("")))

        sut.playerPosition
            .subscribe(onNext: { position in
                positions.append(position)

                if positions.count == 5 {
                    XCTAssertEqual(testValues, positions)
                    exp.fulfill()
                }

                if index < 5 {
                    self.itunesApplicationWrapper.playerPositionMock = testValues[index]
                    index += 1
                }
            })
            .addDisposableTo(disposeBag)

        waitForExpectations(timeout: 6.0, handler: nil)
    }

    func test_NowPlayingIsUpdating() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Optional<iTunesTrackWrapperType>.self)

        sut.nowPlaying
            .subscribe(observer)
            .addDisposableTo(disposeBag)

        let mockTrack = iTunesTrackWrapperMock(
            identifier: "Test id",
            artwork: nil,
            artist: "Berenies",
            title: "Summer Jam",
            isPodcast: true
        )

        scheduler.scheduleAt(10) {
            self.itunesApplicationWrapper.playerStateMock = .playing
            self.itunesApplicationWrapper.currentTrackMock = mockTrack
            self.notificationCenter.notificationBlock!(Notification(name: Notification.Name("")))
        }

        scheduler.start()

        XCTAssertNil(observer.events[0].value.element!)

        let receivedTrack = observer.events[1].value.element!!
        XCTAssertEqual(receivedTrack.identifier, mockTrack.identifier)
        XCTAssertEqual(receivedTrack.artwork, mockTrack.artwork)
        XCTAssertEqual(receivedTrack.artist, mockTrack.artist)
        XCTAssertEqual(receivedTrack.title, mockTrack.title)
        XCTAssertEqual(receivedTrack.isPodcast, mockTrack.isPodcast)
    }
}

// MARK: - Edge cases during update tests

extension iTunesTests {
    func test_SetsDefaultValuesIfAppStateIsUnknown() {
        let scheduler = TestScheduler(initialClock: 0)
        let stateObserver = scheduler.createObserver(PlayerState.self)
        let positionObserver = scheduler.createObserver(Double.self)
        let trackObserver = scheduler.createObserver(Optional<iTunesTrackWrapperType>.self)

        sut.playerState
            .subscribe(stateObserver)
            .addDisposableTo(disposeBag)

        sut.playerPosition
            .subscribe(positionObserver)
            .addDisposableTo(disposeBag)

        sut.nowPlaying
            .subscribe(trackObserver)
            .addDisposableTo(disposeBag)

        scheduler.scheduleAt(10) {
            self.itunesApplicationWrapper.playerStateMock = .unknown
            self.notificationCenter.notificationBlock!(Notification(name: Notification.Name("")))
        }

        scheduler.start()

        XCTAssertEqual(stateObserver.events, [.next(.unknown)])
        XCTAssertEqual(positionObserver.events, [.next(0.0), .next(0.0), .next(0.0)])
        XCTAssertNil(trackObserver.events[0].value.element!)
    }
}

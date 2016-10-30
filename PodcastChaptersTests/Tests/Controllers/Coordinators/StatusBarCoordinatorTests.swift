//
//  StatusBarCoordinatorTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

@testable import PodcastChapters

class StatusBarCoordinatorTests: XCTestCase {
    fileprivate var sut: StatusBarCoordinator!
    fileprivate var popover: PopoverMock!
    fileprivate var statusBarItem: StatusBarItemMock!
    fileprivate var application: NSApplicationMock!

    override func setUp() {
        super.setUp()

        popover = PopoverMock()
        statusBarItem = StatusBarItemMock(eventMonitor: EventMonitor(mask: [.leftMouseDown, .rightMouseDown]))
        application = NSApplicationMock()
        sut = StatusBarCoordinator(popover: popover, statusBarItem: statusBarItem, application: application)
    }

    override func tearDown() {
        super.tearDown()

        popover = nil
        statusBarItem = nil
        application = nil
        sut = nil
    }
}

// MARK: - Event trigger tests

extension StatusBarCoordinatorTests {
    func test_OpenMainViewIsTriggered() {
        let fromView = NSView(frame: NSRect.zero)
        statusBarItem.eventSignal.onNext(.open(fromView))

        if case PopoverMock.ExecutedMethod.showFromView(let view) = popover.executedMethod {
            XCTAssert(view === fromView)
        }
        else {
            XCTFail("Something else was executed than ShowFromView")
        }
    }

    func test_DismissIsTriggered() {
        statusBarItem.eventSignal.onNext(.close)

        if case PopoverMock.ExecutedMethod.dismiss = popover.executedMethod {
            XCTAssertTrue(true)
        }
        else {
            XCTFail("Something else was executed than Dismiss")
        }
    }

    func test_QuitIsTriggered() {
        statusBarItem.eventSignal.onNext(.quit)

        if case NSApplicationMock.ExecutedMethod.terminate = application.executedMethod {
            XCTAssertTrue(true)
        }
        else {
            XCTFail("Something else was executed than Quit")
        }
    }
}

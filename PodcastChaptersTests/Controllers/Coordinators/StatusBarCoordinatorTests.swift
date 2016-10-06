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

    var statusBarCoordinator: StatusBarCoordinator!
    var popover: PopoverMock!
    var statusBarItem: StatusBarItemMock!
    var application: NSApplicationMock!

    override func setUp() {
        super.setUp()

        popover = PopoverMock()
        statusBarItem = StatusBarItemMock(eventMonitor: EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]))
        application = NSApplicationMock()
        statusBarCoordinator = StatusBarCoordinator(popover: popover, statusBarItem: statusBarItem, application: application)
    }

    func testOpenMainViewIsTriggered() {
        let fromView = NSView(frame: NSRect.zero)
        statusBarItem.eventSignal.onNext(.Open(fromView))

        if case PopoverMock.ExecutedMethod.showFromView(let view) = popover.executedMethod {
            XCTAssert(view === fromView)
        }
        else {
            XCTFail("Something else was executed than ShowFromView")
        }
    }

    func testDismissIsTriggered() {
        statusBarItem.eventSignal.onNext(.Close)

        if case PopoverMock.ExecutedMethod.dismiss = popover.executedMethod {
            XCTAssertTrue(true)
        }
        else {
            XCTFail("Something else was executed than Dismiss")
        }
    }

    func testQuitIsTriggered() {
        statusBarItem.eventSignal.onNext(.Quit)

        if case NSApplicationMock.ExecutedMethod.terminate = application.executedMethod {
            XCTAssertTrue(true)
        }
        else {
            XCTFail("Something else was executed than Quit")
        }
    }
}

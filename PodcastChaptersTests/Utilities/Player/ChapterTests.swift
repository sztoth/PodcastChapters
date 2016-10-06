//
//  ChapterTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreMedia
import XCTest

@testable import PodcastChapters

class ChapterTests: XCTestCase {
    func testChapterPosition_Contains() {
        let sut = chapter()

        var testPosition = 6.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")

        testPosition = 1.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")

        testPosition = 10.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }

    func testChapterPosition_OutOfBounds() {
        let sut = chapter()

        var testPosition = 0.5
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")

        testPosition = 0.99
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")

        testPosition = 11.3
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")

        testPosition = 100.0
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")

        testPosition = 0.0
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")

        testPosition = -3.0
        XCTAssertFalse(sut.contains(testPosition), "The \(testPosition) second position is in bounds")
    }

    func testMissingStartCase() {
        let sut = chapter(start: nil)

        let testPosition = 999.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }

    func testMissingDurationCase() {
        let sut = chapter(duration: nil)

        let testPosition = 34.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }

    func testMissingStartAndDurationCase() {
        let sut = chapter(start: nil, duration: nil)

        let testPosition = 34.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }
}

fileprivate extension ChapterTests {
    func chapter(title: String = "Test title", start: CMTime? = CMTime.oneSecond, duration: CMTime? = CMTime.tenSecond) -> Chapter {
        return Chapter(
            cover: nil,
            title: title,
            start: start,
            duration: duration
        )
    }
}

fileprivate extension CMTime {
    @nonobjc static let oneSecond = CMTimeMake(1, 1)
    @nonobjc static let tenSecond = CMTimeMake(10, 1)
}

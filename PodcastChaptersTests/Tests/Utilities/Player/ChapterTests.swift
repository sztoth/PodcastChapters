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

class ChapterTests: XCTestCase {}

// MARK: - Position tests

extension ChapterTests {
    func test_ChapterPosition_Contains() {
        let sut = chapter()
        let positions = [6.0, 1.0, 10.0]

        positions.forEach { position in
            XCTAssertTrue(sut.contains(position), "The \(position) second position is not in bounds")
        }
    }

    func test_ChapterPosition_OutOfBounds() {
        let sut = chapter()
        let positions = [0.5, 0.99, 11.3, 100.0, 0.0, -3.0]

        positions.forEach { position in
            XCTAssertFalse(sut.contains(position), "The \(position) second position is in bounds")
        }
    }
}

// MARK: - Missing property tests

extension ChapterTests {
    func test_MissingStartCase() {
        let sut = chapter(start: nil)

        let testPosition = 999.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }

    func test_MissingDurationCase() {
        let sut = chapter(duration: nil)

        let testPosition = 34.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }

    func test_MissingStartAndDurationCase() {
        let sut = chapter(start: nil, duration: nil)

        let testPosition = 34.0
        XCTAssertTrue(sut.contains(testPosition), "The \(testPosition) second position is not in bounds")
    }
}

// MARK: - Helper

fileprivate extension ChapterTests {
    func chapter(
        title: String = "Test title",
        start: CMTime? = CMTime.oneSecond,
        duration: CMTime? = CMTime.tenSecond) -> Chapter
    {
        return Chapter(
            cover: nil,
            title: title,
            start: start,
            duration: duration
        )
    }
}

// MARK: - Others

fileprivate extension CMTime {
    @nonobjc static let oneSecond = CMTimeMake(1, 1)
    @nonobjc static let tenSecond = CMTimeMake(10, 1)
}

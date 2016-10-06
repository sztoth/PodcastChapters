//
//  Assertion.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import XCTest

func XCTAssertEqual<E>(_ result: Error, _ expectedError: E, message: String = "", file: StaticString = #file, line: UInt = #line) where E: Error, E: Equatable {
    guard let error = result as? E else {
        XCTFail("\(result) is not \(E.self) type", file: file, line: line)
        return
    }
    XCTAssertEqual(error, expectedError, message, file: file, line: line)
}

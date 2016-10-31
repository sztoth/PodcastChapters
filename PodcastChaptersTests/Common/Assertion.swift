//
//  Assertion.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

// codebeat:disable[ARITY]
func XCTAssertEqual<E: Error & Equatable>(_ lhs: Error, _ rhs: E, file: StaticString = #file, line: UInt = #line) {
    guard let error = lhs as? E else {
        XCTFail("\(lhs) is not \(E.self) type", file: file, line: line)
        return
    }
    XCTAssertEqual(error, rhs, "", file: file, line: line)
}

func XCTAssertEqual<T: Equatable>(_ lhs: [Recorded<Event<T>>], _ rhs: [Event<T>], file: StaticString = #file, line: UInt = #line) {
    let mappedLhs = lhs.map({ $0.value })
    XCTAssertEqual(mappedLhs, rhs, file: file, line: line)
}
// codebeat:enable[ARITY]

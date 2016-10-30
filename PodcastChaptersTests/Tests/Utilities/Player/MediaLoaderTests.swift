//
//  MediaLoaderTests.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import iTunesLibrary
import RxSwift
import XCTest

@testable import PodcastChapters

class MediaLoaderTests: XCTestCase {
    fileprivate var mediaLibrary: MediaLibraryMock!
    fileprivate var sut: MediaLoader!
    fileprivate var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        mediaLibrary = MediaLibraryMock()
        sut = MediaLoader(library: mediaLibrary)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        mediaLibrary = nil
        sut = nil
        disposeBag = nil
    }
}

// MARK: - Successfull case

extension MediaLoaderTests {
    func test_ReturnsAnURL() {
        let testURL = URL(string: "http://test")!
        let array: [(Int, URL?)] = [(1, nil), (2, testURL), (3, nil)]
        mediaLibrary.mockMediaItems = array.map({ ITLibMediaItemMock(identifier: $0.0, location: $0.1) })

        sut.URLFor(identifier: "2")
            .subscribe(onNext: { url in
                XCTAssertEqual(url, testURL)
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - All the error cases

extension MediaLoaderTests {
    func test_CannotFindTheItem() {
        sut.URLFor(identifier: "0")
            .subscribe(onError: { error in
                XCTAssertEqual(error, MediaLoader.LibraryError.itemNotFound)
                return
            })
            .addDisposableTo(disposeBag)
    }

    func test_MissingLocationForItem() {
        sut.URLFor(identifier: "1")
            .subscribe(onError: { error in
                XCTAssertEqual(error, MediaLoader.LibraryError.itemNotFound)
                return
            })
            .addDisposableTo(disposeBag)
    }

    func test_LibraryNotReloading() {
        mediaLibrary.mockReloadResponse = false

        sut.URLFor(identifier: "3")
            .subscribe(onError: { error in
                XCTAssertEqual(error, MediaLoader.LibraryError.libraryNotReloaded)
                return
            })
            .addDisposableTo(disposeBag)
    }

    func test_InvalidIdentifier() {
        sut.URLFor(identifier: "test")
            .subscribe(onError: { error in
                XCTAssertEqual(error, MediaLoader.LibraryError.persistentIDInvalid)
                return
            })
            .addDisposableTo(disposeBag)
    }
}

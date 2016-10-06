//
//  MediaLibraryMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import iTunesLibrary

@testable import PodcastChapters

class MediaLibraryMock: MediaLibraryType {
    var allMediaItems: [ITLibMediaItem] {
        allItemsAccessed = true
        guard let mockMediaItems = mockMediaItems else { return [ITLibMediaItem]() }
        return mockMediaItems
    }
    var mockMediaItems: [ITLibMediaItemMock]?
    var mockReloadResponse = true

    fileprivate(set) var allItemsAccessed = false
    fileprivate(set) var reloadCalled = false

    init() {
        mockMediaItems = [1, 2, 3].map({ ITLibMediaItemMock(identifier: $0) })
    }
}

extension MediaLibraryMock {
    func reloadData() -> Bool {
        return mockReloadResponse
    }
}

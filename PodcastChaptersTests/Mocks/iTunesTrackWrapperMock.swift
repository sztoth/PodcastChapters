//
//  iTunesTrackWrapperMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit

@testable import PodcastChapters

class iTunesTrackWrapperMock: NSObject {
    fileprivate let identifierMock: String
    fileprivate let artworkMock: NSImage?
    fileprivate let artistMock: String
    fileprivate let titleMock: String
    fileprivate let isPodcastMock: Bool

    init(
        identifier: String,
        artwork: NSImage?,
        artist: String,
        title: String,
        isPodcast: Bool
    ) {
        identifierMock = identifier
        artworkMock = artwork
        artistMock = artist
        titleMock = title
        isPodcastMock = isPodcast

        super.init()
    }
}

extension iTunesTrackWrapperMock: iTunesTrackWrapperType {
    var identifier: String {
        return identifierMock
    }
    var artwork: NSImage? {
        return artworkMock
    }
    var artist: String {
        return artistMock
    }
    var title: String {
        return titleMock
    }
    var isPodcast: Bool {
        return isPodcastMock
    }
}

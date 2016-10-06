//
//  ITLibMediaItemMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import iTunesLibrary

class ITLibMediaItemMock: ITLibMediaItem {
    override var persistentID: NSNumber {
        return NSNumber(integerLiteral: customIdentifier)
    }
    override var location: URL? {
        return customLocation
    }

    fileprivate let customIdentifier: Int
    fileprivate let customLocation: URL?

    init(identifier: Int, location: URL? = nil) {
        customIdentifier = identifier
        customLocation = location
    }
}

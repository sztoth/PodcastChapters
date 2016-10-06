//
//  MediaLoaderMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

@testable import PodcastChapters

class MediaLoaderMock: MediaLoader {
    override init(library: MediaLibraryType = MediaLibraryMock()) {
        super.init(library: library)
    }
}

//
//  ITLibrary+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 09. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import iTunesLibrary

protocol MediaLibraryType {
    var allMediaItems: [ITLibMediaItem] { get }

    func reloadData() -> Bool
}

extension ITLibrary: MediaLibraryType {}

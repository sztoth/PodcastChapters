//
//  CollectionView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 01..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class CollectionView: NSCollectionView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        ColorSettings.mainBackgroundColor.setFill()
        NSRectFill(dirtyRect)
    }
}

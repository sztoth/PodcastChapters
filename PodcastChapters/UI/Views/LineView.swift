//
//  LineView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 01..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class LineView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        ColorSettings.textColor.setFill()
        NSRectFill(dirtyRect)
    }
    
}

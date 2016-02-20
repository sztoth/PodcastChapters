//
//  PasteBoard.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class PasteBoard {

    class func copy(content: String) {
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()
        pasteBoard.setString(content, forType: NSPasteboardTypeString)
    }
}
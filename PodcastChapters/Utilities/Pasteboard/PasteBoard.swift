//
//  PasteBoard.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

class PasteBoard {

    fileprivate let pasteBoard: NSPasteboard
    fileprivate let contentStripper: PasteBoardContentStripper

    init(pasteBoard: NSPasteboard = NSPasteboard.general(), contentStripper: PasteBoardContentStripper = PasteBoardContentStripper()) {
        self.pasteBoard = pasteBoard
        self.contentStripper = contentStripper
    }
}

extension PasteBoard {

    func copy(_ content: String) {
        let processedContent = contentStripper.strip(content)

        pasteBoard.clearContents()
        pasteBoard.setString(processedContent, forType: NSPasteboardTypeString)
    }
}

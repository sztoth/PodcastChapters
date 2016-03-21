//
//  PasteBoard.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class PasteBoard {

    private let pasteBoard: NSPasteboard
    private let contentStripper: PasteBoardContentStripper

    init(pasteBoard: NSPasteboard = NSPasteboard.generalPasteboard(), contentStripper: PasteBoardContentStripper = PasteBoardContentStripper()) {
        self.pasteBoard = pasteBoard
        self.contentStripper = contentStripper
    }
}

extension PasteBoard {

    func copy(content: String) {
        let processedContent = contentStripper.strip(content)

        pasteBoard.clearContents()
        pasteBoard.setString(processedContent, forType: NSPasteboardTypeString)
    }
}

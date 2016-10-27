//
//  PasteBoard.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

protocol PasteBoardType {
    func copy(_ content: String)
}

class PasteBoard {
    fileprivate let pasteBoard: NSPasteboard
    fileprivate let contentStripper: PasteBoardContentStripper

    init(
        pasteBoard: NSPasteboard = NSPasteboard.general(),
        contentStripper: PasteBoardContentStripper = PasteBoardContentStripper()
    ) {
        self.pasteBoard = pasteBoard
        self.contentStripper = contentStripper
    }
}

// MARK: - PasteBoardType

extension PasteBoard: PasteBoardType {
    func copy(_ content: String) {
        pasteBoard.clearContents()

        let processedContent = contentStripper.strip(content)
        pasteBoard.setString(processedContent, forType: NSPasteboardTypeString)
    }
}

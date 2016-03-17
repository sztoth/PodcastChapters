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
        var processed = content.stringByReplacingOccurrencesOfString("\"", withString: "")

        if let regex = try? NSRegularExpression(pattern: "\\[.*\\]", options: .CaseInsensitive) {
            let range = NSRange(location: 0, length: processed.characters.count)
            processed = regex.stringByReplacingMatchesInString(processed, options: .WithTransparentBounds, range: range, withTemplate: "")
        }

        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()
        pasteBoard.setString(processed, forType: NSPasteboardTypeString)
    }
}
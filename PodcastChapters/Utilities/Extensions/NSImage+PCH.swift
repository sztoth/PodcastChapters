//
//  NSImage+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

extension NSImage {

    func imageApplyingTintColor(_ color: NSColor) -> NSImage? {
        if let copy = copy() as? NSImage {
            copy.lockFocus()

            color.set()

            let rect = NSRect(origin: NSPoint.zero, size: copy.size)
            NSRectFillUsingOperation(rect, .sourceAtop)

            copy.unlockFocus()

            return copy
        }

        return nil
    }
}

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
        guard let imageCopy = copy() as? NSImage else { return nil }

        imageCopy.lockFocus()

        color.set()

        let rect = NSRect(origin: NSPoint.zero, size: imageCopy.size)
        NSRectFillUsingOperation(rect, .sourceAtop)

        imageCopy.unlockFocus()

        return imageCopy
    }
}

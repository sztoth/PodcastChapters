//
//  NSPopover+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

extension NSPopover {

    func showFromView(view: NSView, preferredEdge: NSRectEdge = NSRectEdge.MinY) {
        showRelativeToRect(view.bounds, ofView: view, preferredEdge: preferredEdge)
    }
}

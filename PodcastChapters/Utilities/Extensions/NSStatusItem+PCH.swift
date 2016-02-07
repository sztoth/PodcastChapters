//
//  NSStatusItem+PC.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxCocoa

// MARK: - Convinience creation method

extension NSStatusItem {

    class func pch_statusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.button?.image = NSImage(named: "Status Bar Image")

        return statusItem
    }
}

// MARK: - RxSwift extension

extension NSStatusItem {

    var rx_tap: ControlEvent<Void>? {
        return button?.rx_controlEvent
    }
}
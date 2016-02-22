//
//  NSStatusItem+PC.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension NSStatusItem {

    class func pch_statusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        let statusItemView = StatusItemView(statusItem: statusItem)
        statusItem.view = statusItemView

        return statusItem
    }

    var highlighted: Bool {
        get {
            if let view = view as? StatusItemView {
                return view.highlight
            }

            return false
        }
        set(value) {
            if let view = view as? StatusItemView {
                view.highlight = value
            }
        }
    }
}

// MARK: - RxSwift

extension NSStatusItem {

    var event: Observable<StatusItemViewEvent>? {
        if let view = view as? StatusItemView {
            return view.event
        }

        return nil
    }
}
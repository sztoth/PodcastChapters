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
    static func pch_statusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        let statusItemView = StatusItemView(statusItem: statusItem)
        statusItem.view = statusItemView

        return statusItem
    }
}

extension NSStatusItem {
    var highlighted: Bool {
        get {
            guard let view = view as? StatusItemView else { return false }
            return view.highlight
        }
        set {
            guard let view = view as? StatusItemView else { return }
            view.highlight = newValue
        }
    }
}

// MARK: - RxSwift

extension NSStatusItem {
    var event: Observable<StatusItemView.Event>? {
        guard let view = view as? StatusItemView else { return nil }
        return view.event
    }
}

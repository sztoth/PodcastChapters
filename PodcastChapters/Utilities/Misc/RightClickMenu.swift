//
//  RightClickMenu.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation
import RxSwift

class RightClickMenu: NSMenu {
    var itemSelected: Observable<Option> {
        return _itemSelected.asObserver()
    }

    fileprivate let _itemSelected = PublishSubject<Option>()

    init() {
        super.init(title: "")

        // TODO: - Settings will arrive later
//        let settingsItem = NSMenuItem(title: "Settings", action: Selector("settingsSelected"), keyEquivalent: "")
//        settingsItem.target = self
//        addItem(settingsItem)
//
//        let separator = NSMenuItem.separatorItem()
//        addItem(separator)

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitSelected), keyEquivalent: "")
        quitItem.target = self
        addItem(quitItem)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Selection handling

extension RightClickMenu {
    func settingsSelected() {
        _itemSelected.onNext(.settings)
    }

    func quitSelected() {
        _itemSelected.onNext(.quit)
    }
}

// MARK: - Options

extension RightClickMenu {
    enum Option {
        case settings
        case quit
    }
}

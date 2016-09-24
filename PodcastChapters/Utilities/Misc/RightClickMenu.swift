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

enum RightClickMenuOption {
    case settings
    case quit
}

class RightClickMenu: NSMenu {

    var itemSelected: Observable<RightClickMenuOption> {
        return _itemSelected.asObserver()
    }

    fileprivate let _itemSelected = PublishSubject<RightClickMenuOption>()

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

extension RightClickMenu {

    func settingsSelected() {
        _itemSelected.onNext(.settings)
    }

    func quitSelected() {
        _itemSelected.onNext(.quit)
    }
}

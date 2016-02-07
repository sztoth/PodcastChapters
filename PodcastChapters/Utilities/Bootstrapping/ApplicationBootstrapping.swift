//
//  ApplicationBootstrapping.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ApplicationBootstrapping: Bootstrapping {

    var coordinator: AppCoordinator?

    func bootstrap(bootstrapped: Bootstrapped) throws {
        let popup = NSPopover()
        let itunesMonitor = iTunesMonitor()

        let statusBarItem = StatusBarItem(eventMonitor: EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]))
        let contentCoordinator = ContentCoordinator(popup: popup, itunesMonitor: itunesMonitor)
        let statusBarCoordinator = StatusBarCoordinator(popup: popup, statusBarItem: statusBarItem, contentCoordinator: contentCoordinator)

        coordinator = AppCoordinator(itunesMonitor: itunesMonitor, statusBarCoordinator: statusBarCoordinator)
    }
}

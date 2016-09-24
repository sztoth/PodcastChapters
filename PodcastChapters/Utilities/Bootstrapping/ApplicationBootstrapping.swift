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

    func bootstrap(_ bootstrapped: Bootstrapped) throws {
        let popover = Popover()

        let podcastMonitor = PodcastMonitor()

        let statusBarItem = StatusBarItem(eventMonitor: EventMonitor(mask: [.leftMouseDown, .rightMouseDown]))
        let contentCoordinator = ContentCoordinator(popover: popover, podcastMonitor: podcastMonitor)
        let statusBarCoordinator = StatusBarCoordinator(popover: popover, statusBarItem: statusBarItem)

        coordinator = AppCoordinator(podcastMonitor: podcastMonitor, statusBarCoordinator: statusBarCoordinator, contentCoordinator: contentCoordinator)
    }
}

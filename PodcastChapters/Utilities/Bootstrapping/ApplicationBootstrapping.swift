//
//  ApplicationBootstrapping.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import iTunesLibrary

class ApplicationBootstrapping {
    var coordinator: AppCoordinator?
    var notificationCenter: NotificationCenter?
}

extension ApplicationBootstrapping: Bootstrapping {
    func bootstrap(_ bootstrapped: Bootstrapped) throws {
        let popover = Popover()

        let itLibrary = try ITLibrary(apiVersion: "1.0")
        let mediaLoader = MediaLoader(library: itLibrary)
        let notificationCenter = NotificationCenter()
        let podcastMonitor = PodcastMonitor(mediaLoader: mediaLoader, notificationCenter: notificationCenter)

        let statusBarItem = StatusBarItem(eventMonitor: EventMonitor(mask: [.leftMouseDown, .rightMouseDown]))
        let contentCoordinator = ContentCoordinator(popover: popover, podcastMonitor: podcastMonitor)
        let statusBarCoordinator = StatusBarCoordinator(popover: popover, statusBarItem: statusBarItem)

        coordinator = AppCoordinator(
            podcastMonitor: podcastMonitor,
            statusBarCoordinator: statusBarCoordinator,
            contentCoordinator: contentCoordinator
        )
        self.notificationCenter = notificationCenter
    }
}

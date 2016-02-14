//
//  AppCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class AppCoordinator {

    private let podcastMonitor: PodcastMonitor
    private let statusBarCoordinator: StatusBarCoordinator

    init(podcastMonitor: PodcastMonitor, statusBarCoordinator: StatusBarCoordinator) {
        self.podcastMonitor = podcastMonitor
        self.statusBarCoordinator = statusBarCoordinator
    }
}

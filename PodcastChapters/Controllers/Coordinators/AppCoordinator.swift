//
//  AppCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class AppCoordinator {

    private let itunesMonitor: iTunesMonitor
    private let statusBarCoordinator: StatusBarCoordinator

    init(itunesMonitor: iTunesMonitor, statusBarCoordinator: StatusBarCoordinator) {
        self.itunesMonitor = itunesMonitor
        self.statusBarCoordinator = statusBarCoordinator
    }
}

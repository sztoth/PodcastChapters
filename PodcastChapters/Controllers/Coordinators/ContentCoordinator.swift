//
//  ContentCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ContentCoordinator {

    private let popup: NSPopover
    private let podcastMonitor: PodcastMonitor

    init(popup: NSPopover, podcastMonitor: PodcastMonitor) {
        self.popup = popup
        self.podcastMonitor = podcastMonitor

        let chaptersViewModel = ChaptersViewModel()
        self.popup.contentViewController = ChaptersViewController(viewModel: chaptersViewModel)
    }
}

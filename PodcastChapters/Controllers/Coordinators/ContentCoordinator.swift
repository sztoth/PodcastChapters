//
//  ContentCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ContentCoordinator {

    private let popover: Popover
    private let podcastMonitor: PodcastMonitor

    init(popover: Popover, podcastMonitor: PodcastMonitor) {
        self.popover = popover
        self.podcastMonitor = podcastMonitor

        let chaptersViewModel = ChaptersViewModel(podcastMonitor: self.podcastMonitor)
        self.popover.content = ChaptersViewController(viewModel: chaptersViewModel)
    }
}

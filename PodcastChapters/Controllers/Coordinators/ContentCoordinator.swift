//
//  ContentCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class ContentCoordinator {

    private let popover: Popover
    private let podcastMonitor: PodcastMonitor
    private let chaptersController: ChaptersViewController
    private let otherContentController: OtherContentViewController
    private let disposeBag = DisposeBag()

    init(popover: Popover, podcastMonitor: PodcastMonitor) {
        self.popover = popover
        self.podcastMonitor = podcastMonitor

        // TODO: - Rethink the force unwrap
        let chaptersViewModel = ChaptersViewModel(podcastMonitor: self.podcastMonitor)
        self.chaptersController = ChaptersViewController(viewModel: chaptersViewModel)!
        
        self.otherContentController = OtherContentViewController()!

        self.podcastMonitor.isPodcast
            .subscribeNext { isPodcast in
                if isPodcast {
                    self.popover.content = self.chaptersController
                }
                else {
                    self.popover.content = self.otherContentController
                }
            }
            .addDisposableTo(disposeBag)
    }
}

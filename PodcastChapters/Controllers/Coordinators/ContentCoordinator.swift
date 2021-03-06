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
    fileprivate let popover: Popover
    fileprivate let podcastMonitor: PodcastMonitorType
    fileprivate let chaptersController: ChaptersViewController
    fileprivate let otherContentController: OtherContentViewController
    fileprivate let disposeBag = DisposeBag()

    init(popover: Popover, podcastMonitor: PodcastMonitorType) {
        self.popover = popover
        self.podcastMonitor = podcastMonitor

        // TODO: - Rethink the force unwrap
        let chaptersViewModel = ChaptersViewModel(podcastMonitor: self.podcastMonitor)
        chaptersController = ChaptersViewController(viewModel: chaptersViewModel)!
        
        otherContentController = OtherContentViewController()!

        podcastMonitor.podcast
            .subscribe(onNext: { isPodcast in
                if isPodcast {
                    self.popover.content = self.chaptersController
                }
                else {
                    self.popover.content = self.otherContentController
                }
            })
            .addDisposableTo(disposeBag)
    }
}

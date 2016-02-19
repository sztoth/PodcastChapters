//
//  StatusBarCoordinator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class StatusBarCoordinator {

    private let popover: Popover
    private let statusBarItem: StatusBarItem
    private let contentCoordinator: ContentCoordinator
    private let disposeBag = DisposeBag()

    init(popover: Popover, statusBarItem: StatusBarItem, contentCoordinator: ContentCoordinator) {
        self.popover = popover
        self.statusBarItem = statusBarItem
        self.contentCoordinator = contentCoordinator

        self.statusBarItem.event
            .subscribeNext { event in
                switch event {
                case .Open(let button):
                    self.popover.showFromView(button)
                case .Close:
                    self.popover.dismiss()
                }
            }
            .addDisposableTo(disposeBag)
    }
}

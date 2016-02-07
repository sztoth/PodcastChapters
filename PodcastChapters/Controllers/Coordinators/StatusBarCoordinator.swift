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

    private let popup: NSPopover
    private let statusBarItem: StatusBarItem
    private let contentCoordinator: ContentCoordinator
    private let disposeBag = DisposeBag()

    init(popup: NSPopover, statusBarItem: StatusBarItem, contentCoordinator: ContentCoordinator) {
        self.popup = popup
        self.statusBarItem = statusBarItem
        self.contentCoordinator = contentCoordinator

        self.statusBarItem.event
            .subscribeNext { event in
                switch event {
                case .Open(let button):
                    self.popup.showFromView(button)
                case .Close:
                    self.popup.performClose(nil)
                }
            }
            .addDisposableTo(disposeBag)
    }
}

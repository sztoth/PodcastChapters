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
    private let disposeBag = DisposeBag()

    init(popover: Popover, statusBarItem: StatusBarItem) {
        self.popover = popover
        self.statusBarItem = statusBarItem

        self.statusBarItem.event
            .subscribeNext { event in
                switch event {
                case .Open(let view):
                    self.popover.showFromView(view)
                case .Close:
                    self.popover.dismiss()
                case .Quit:
                    NSApplication.sharedApplication().terminate(nil)
                case .OpenSettings:
                    print("Later")
                }
            }
            .addDisposableTo(disposeBag)
    }
}

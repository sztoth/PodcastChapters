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
    fileprivate let popover: Popover
    fileprivate let statusBarItem: StatusBarItem
    fileprivate let application: NSApplicationType
    fileprivate let disposeBag = DisposeBag()

    init(popover: Popover, statusBarItem: StatusBarItem, application: NSApplicationType = NSApplication.shared()) {
        self.popover = popover
        self.statusBarItem = statusBarItem
        self.application = application

        self.statusBarItem.event
            .subscribe(onNext: { event in
                switch event {
                case .open(let view):
                    self.popover.show(from: view)
                case .close:
                    self.popover.hide()
                case .quit:
                    self.application.terminate(nil)
                case .openSettings:
                    print("Later")
                }
            })
            .addDisposableTo(disposeBag)
    }
}

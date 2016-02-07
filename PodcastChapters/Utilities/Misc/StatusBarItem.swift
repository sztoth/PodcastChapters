//
//  StatusBarItem.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

enum StatusBarItemEvent {
    case Open(NSButton)
    case Close
}

private enum StatusBarItemStatus {
    case Open
    case Closed
}

class StatusBarItem {

    var event: Observable<StatusBarItemEvent> {
        return visibility.asObservable().map({ status -> StatusBarItemEvent in
            switch status {
            case .Open:
                return .Open(self.statusItem.button!)
            case .Closed:
                return .Close
            }
        })
    }

    private let visibility = Variable(StatusBarItemStatus.Closed)
    private let statusItem: NSStatusItem
    private let eventMonitor: EventMonitor
    private let disposeBag = DisposeBag()

    init(statusItem: NSStatusItem = NSStatusItem.pch_statusItem(), eventMonitor: EventMonitor) {
        self.statusItem = statusItem
        self.eventMonitor = eventMonitor

        self.statusItem.rx_tap?
            .map({ [unowned self] _ -> StatusBarItemStatus in
                switch self.visibility.value {
                case .Open:
                    self.eventMonitor.stop()
                    return .Closed
                case .Closed:
                    self.eventMonitor.start()
                    return .Open
                }
            })
            .bindTo(visibility)
            .addDisposableTo(disposeBag)

        self.eventMonitor.event
            .map({ [unowned self] _ -> StatusBarItemStatus in
                self.eventMonitor.stop()
                return StatusBarItemStatus.Closed
            })
            .bindTo(visibility)
            .addDisposableTo(disposeBag)

        self.eventMonitor.start()
    }
}

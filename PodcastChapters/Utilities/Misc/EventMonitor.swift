//
//  EventMonitor.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class EventMonitor {

    var event: Observable<AnyObject> {
        return eventSignal.asObservable()
    }

    private let eventSignal = PublishSubject<AnyObject>()
    private var monitor: AnyObject?
    private let mask: NSEventMask

    init(mask: NSEventMask) {
        self.mask = mask
    }

    deinit {
        stop()
    }

    func start() {
        guard monitor == nil else {
            return
        }

        monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask) { [unowned self] event in
            self.eventSignal.onNext(event)
        }
    }

    func stop() {
        guard let monitor = monitor else {
            return
        }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}

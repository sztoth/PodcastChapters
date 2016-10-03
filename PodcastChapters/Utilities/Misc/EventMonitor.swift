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
        return _event.asObservable()
    }

    fileprivate let _event = PublishSubject<AnyObject>()
    fileprivate let mask: NSEventMask

    fileprivate var monitor: Any?

    init(mask: NSEventMask) {
        self.mask = mask
    }

    deinit {
        stop()
    }

    func start() {
        guard monitor == nil else { return }

        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask) { [unowned self] event in
            self._event.onNext(event)
        }
    }

    func stop() {
        guard let monitor = monitor else { return }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}

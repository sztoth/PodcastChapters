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

enum StatusBarEvent {
    case open(NSView)
    case close
    case openSettings
    case quit
}

class StatusBarItem {

    var event: Observable<StatusBarEvent> {
        return _event.asObservable()
    }

    fileprivate let _event = PublishSubject<StatusBarEvent>()
    fileprivate let statusItem: NSStatusItem
    fileprivate let eventMonitor: EventMonitor
    fileprivate let disposeBag = DisposeBag()
    fileprivate var visible = false

    init(statusItem: NSStatusItem = NSStatusItem.pch_statusItem(), eventMonitor: EventMonitor) {
        self.statusItem = statusItem
        self.eventMonitor = eventMonitor

        self.statusItem.event?
            .map { [unowned self] event -> StatusBarEvent in
                switch event {
                case .toggleMainView(let view):
                    return self.toggleFromView(view)
                case .openSettings:
                    return .openSettings
                case .quit:
                    return .quit
                }
            }
            .bindTo(_event)
            .addDisposableTo(disposeBag)

        self.eventMonitor.event
            .map({ [unowned self] _ -> StatusBarEvent in
                self.mainViewWillHide()
                return .close
            })
            .bindTo(_event)
            .addDisposableTo(disposeBag)

        self.eventMonitor.start()
    }
}

private extension StatusBarItem {

    func toggleFromView(_ view: NSView) -> StatusBarEvent {
        if visible {
            mainViewWillHide()
            return .close
        }
        else {
            mainViewWillShow()
            return .open(view)
        }
    }

    func mainViewWillShow() {
        visible = true
        statusItem.highlighted = true
        eventMonitor.start()
    }

    func mainViewWillHide() {
        visible = false
        statusItem.highlighted = false
        eventMonitor.stop()
    }
}

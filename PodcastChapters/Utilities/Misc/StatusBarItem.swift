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
    case Open(NSView)
    case Close
    case OpenSettings
    case Quit
}

class StatusBarItem {

    var event: Observable<StatusBarEvent> {
        return _event.asObservable()
    }

    private let _event = PublishSubject<StatusBarEvent>()
    private let statusItem: NSStatusItem
    private let eventMonitor: EventMonitor
    private let disposeBag = DisposeBag()
    private var visible = false

    init(statusItem: NSStatusItem = NSStatusItem.pch_statusItem(), eventMonitor: EventMonitor) {
        self.statusItem = statusItem
        self.eventMonitor = eventMonitor

        self.statusItem.event?
            .map { [unowned self] event -> StatusBarEvent in
                switch event {
                case .ToggleMainView(let view):
                    return self.toggleFromView(view)
                case .OpenSettings:
                    return .OpenSettings
                case .Quit:
                    return .Quit
                }
            }
            .bindTo(_event)
            .addDisposableTo(disposeBag)

        self.eventMonitor.event
            .map({ [unowned self] _ -> StatusBarEvent in
                self.mainViewWillHide()
                return .Close
            })
            .bindTo(_event)
            .addDisposableTo(disposeBag)

        self.eventMonitor.start()
    }
}

private extension StatusBarItem {

    func toggleFromView(view: NSView) -> StatusBarEvent {
        if visible {
            mainViewWillHide()
            return .Close
        }
        else {
            mainViewWillShow()
            return .Open(view)
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

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

class StatusBarItem {
    var event: Observable<Event> {
        return _event.asObservable()
    }

    fileprivate let _event = PublishSubject<Event>()
    fileprivate let statusItem: NSStatusItem
    fileprivate let eventMonitor: EventMonitor
    fileprivate let disposeBag = DisposeBag()

    fileprivate var visible = false

    init(statusItem: NSStatusItem = NSStatusItem.pch_statusItem(), eventMonitor: EventMonitor) {
        self.statusItem = statusItem
        self.eventMonitor = eventMonitor

        setupBindings()

        self.eventMonitor.start()
    }
}

// MARK: - Setup

fileprivate extension StatusBarItem {
    func setupBindings() {
        statusItem.event?
            .map(statusItemEvent)
            .bindTo(_event)
            .addDisposableTo(disposeBag)

        statusItem.event?
            .filter(isToggleEvent)
            .subscribe { _ in
                self.toggle()
            }
            .addDisposableTo(disposeBag)

        eventMonitor.event
            .subscribe { _ in
                self.mainViewWillHide()
            }
            .addDisposableTo(disposeBag)

        eventMonitor.event
            .map { _ in Event.close }
            .bindTo(_event)
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Visibility methods

fileprivate extension StatusBarItem {
    func toggle() {
        visible ? mainViewWillHide() : mainViewWillShow()
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

// MARK: - RxSwift methods

fileprivate extension StatusBarItem {
    func isToggleEvent(_ event: StatusItemView.Event) -> Bool {
        if case .toggleMainView(_) = event {
            return true
        }
        return false
    }

    func statusItemEvent(from event: StatusItemView.Event) -> Event {
        switch event {
        case .toggleMainView(_) where visible:
            return .close
        case .toggleMainView(let view) where !visible:
            return .open(view)
        case .openSettings:
            return .openSettings
        case .quit:
            return .quit
        default:
            fatalError("Should not have more options")
        }
    }
}

// MARK: - Event

extension StatusBarItem {
    enum Event {
        case open(NSView)
        case close
        case openSettings
        case quit
    }
}

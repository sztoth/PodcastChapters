//
//  StatusItemView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

enum StatusItemViewEvent {
    case toggleMainView(NSView)
    case openSettings
    case quit
}

class StatusItemView: NSControl {

    var event: Observable<StatusItemViewEvent> {
        return _event.asObservable()
    }

    var highlight: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    fileprivate let _event = PublishSubject<StatusItemViewEvent>()
    fileprivate let disposeBag = DisposeBag()
    fileprivate let statusItem: NSStatusItem
    fileprivate let rightClickMenu: RightClickMenu
    fileprivate let image: NSImage
    
    fileprivate var mouseDown = false
    fileprivate var menuVisible = false

    init(statusItem: NSStatusItem, rightClickMenu: RightClickMenu = RightClickMenu()) {
        self.statusItem = statusItem
        self.rightClickMenu = rightClickMenu
        image = NSImage(named: "Status Bar Image")!.imageApplyingTintColor(NSColor.white)!
        highlight = false

        let height = NSStatusBar.system().thickness
        let frame = NSRect(x: 0.0, y: 0.0, width: 30.0, height: height)
        super.init(frame: frame)

        self.rightClickMenu.itemSelected
            .map { (option) -> StatusItemViewEvent in
                switch option {
                case .settings:
                    return .openSettings
                case .quit:
                    return .quit
                }
            }
            .bindTo(_event)
            .addDisposableTo(disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        let highlighted = mouseDown || menuVisible || highlight

        let yOffset = CGFloat(2.0)
        let height = bounds.height - 2 * yOffset
        let xOffset = round((bounds.width - height) / CGFloat(2.0))
        let imageRect = NSRect(x: xOffset, y: yOffset, width: height, height: height)

        statusItem.drawStatusBarBackground(in: bounds, withHighlight: highlighted)
        image.draw(in: imageRect, from: NSRect.zero, operation: .sourceOver, fraction: 1)
    }
}

// MARK: - Private

private extension StatusItemView {

    func mouseStatusChanged(started: Bool) {
        mouseDown = started
        setNeedsDisplay()
    }

    func menuVisibilityChanged(visible: Bool) {
        menuVisible = visible
        setNeedsDisplay()
    }

    func showMainView() {
        _event.onNext(.toggleMainView(self))
    }

    func unregisterFromNotification(_ notification: Foundation.Notification) {
        Foundation.NotificationCenter.pch_removeObserver(self, name: notification.name.rawValue, object: notification.object as AnyObject?)
    }
}

// MARK: - Click handling

extension StatusItemView {

    override func mouseDown(with theEvent: NSEvent) {
        mouseStatusChanged(started: true)
    }

    override func mouseUp(with theEvent: NSEvent) {
        guard mouseDown == true else {
            return
        }

        if theEvent.modifierFlags.contains(.control) {
            showMenu()
        }
        else {
            showMainView()
        }

        mouseStatusChanged(started: false)
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        mouseStatusChanged(started: true)
    }

    override func rightMouseUp(with theEvent: NSEvent) {
        guard mouseDown == true else {
            return
        }

        showMenu()
        mouseStatusChanged(started: false)
    }
}

// MARK: - Menu handling

private extension StatusItemView {

    func showMenu() {
        Foundation.NotificationCenter.pch_addObserverForName(NSNotification.Name.NSMenuDidBeginTracking.rawValue, object: rightClickMenu) { [weak self] notification in
            self?.menuVisibilityChanged(visible: true)
            self?.unregisterFromNotification(notification)
        }

        Foundation.NotificationCenter.pch_addObserverForName(NSNotification.Name.NSMenuDidEndTracking.rawValue, object: rightClickMenu) { [weak self] notification in
            self?.menuVisibilityChanged(visible: false)
            self?.unregisterFromNotification(notification)
        }

        statusItem.popUpMenu(rightClickMenu)
    }
}

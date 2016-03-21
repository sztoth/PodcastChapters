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
    case ToggleMainView(NSView)
    case OpenSettings
    case Quit
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

    private let _event = PublishSubject<StatusItemViewEvent>()
    private let disposeBag = DisposeBag()
    private let statusItem: NSStatusItem
    private let rightClickMenu: RightClickMenu
    private let image: NSImage
    private var mouseDown = false
    private var menuVisible = false

    init(statusItem: NSStatusItem, rightClickMenu: RightClickMenu = RightClickMenu()) {
        self.statusItem = statusItem
        self.rightClickMenu = rightClickMenu
        image = NSImage(named: "Status Bar Image")!.imageApplyingTintColor(NSColor.whiteColor())!
        highlight = false

        let height = NSStatusBar.systemStatusBar().thickness
        let frame = NSRect(x: 0.0, y: 0.0, width: 30.0, height: height)
        super.init(frame: frame)

        self.rightClickMenu.itemSelected
            .map { (option) -> StatusItemViewEvent in
                switch option {
                case .Settings:
                    return .OpenSettings
                case .Quit:
                    return .Quit
                }
            }
            .bindTo(_event)
            .addDisposableTo(disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(dirtyRect: NSRect) {
        let highlighted = mouseDown || menuVisible || highlight

        let yOffset = CGFloat(2.0)
        let height = bounds.height - 2 * yOffset
        let xOffset = round((bounds.width - height) / CGFloat(2.0))
        let imageRect = NSRect(x: xOffset, y: yOffset, width: height, height: height)

        statusItem.drawStatusBarBackgroundInRect(bounds, withHighlight: highlighted)
        image.drawInRect(imageRect, fromRect: NSRect.zero, operation: .CompositeSourceOver, fraction: 1)
    }
}

// MARK: - Private

private extension StatusItemView {

    func mouseStatusChanged(started started: Bool) {
        mouseDown = started
        setNeedsDisplay()
    }

    func menuVisibilityChanged(visible visible: Bool) {
        menuVisible = visible
        setNeedsDisplay()
    }

    func showMainView() {
        _event.onNext(.ToggleMainView(self))
    }

    func unregisterFromNotification(notification: NSNotification) {
        NSNotificationCenter.pch_removeObserver(self, name: notification.name, object: notification.object)
    }
}

// MARK: - Click handling

extension StatusItemView {

    override func mouseDown(theEvent: NSEvent) {
        mouseStatusChanged(started: true)
    }

    override func mouseUp(theEvent: NSEvent) {
        guard mouseDown == true else {
            return
        }

        if theEvent.modifierFlags.contains(.ControlKeyMask) {
            showMenu()
        }
        else {
            showMainView()
        }

        mouseStatusChanged(started: false)
    }

    override func rightMouseDown(theEvent: NSEvent) {
        mouseStatusChanged(started: true)
    }

    override func rightMouseUp(theEvent: NSEvent) {
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
        NSNotificationCenter.pch_addObserverForName(NSMenuDidBeginTrackingNotification, object: rightClickMenu) { [weak self] notification in
            self?.menuVisibilityChanged(visible: true)
            self?.unregisterFromNotification(notification)
        }

        NSNotificationCenter.pch_addObserverForName(NSMenuDidEndTrackingNotification, object: rightClickMenu) { [weak self] notification in
            self?.menuVisibilityChanged(visible: false)
            self?.unregisterFromNotification(notification)
        }

        statusItem.popUpStatusItemMenu(rightClickMenu)
    }
}

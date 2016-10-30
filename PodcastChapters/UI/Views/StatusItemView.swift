//
//  StatusItemView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class StatusItemView: NSControl {
    var event: Observable<Event> {
        return _event.asObservable()
    }
    var highlight: Bool = false {
        didSet { setNeedsDisplay() }
    }

    fileprivate let _event = PublishSubject<Event>()
    fileprivate let disposeBag = DisposeBag()
    fileprivate let statusItem: NSStatusItem
    fileprivate let rightClickMenu: RightClickMenu
    fileprivate let notificationCenter: NotificationCenterType
    fileprivate let image: NSImage

    fileprivate var notificationTokens: [NSObjectProtocol]?
    fileprivate var mouseDown = false {
        didSet { setNeedsDisplay() }
    }
    fileprivate var menuVisible = false {
        didSet { setNeedsDisplay() }
    }

    init(
        statusItem: NSStatusItem,
        rightClickMenu: RightClickMenu = RightClickMenu(),
        notificationCenter: NotificationCenterType = NotificationCenter.default
    ) {
        self.statusItem = statusItem
        self.rightClickMenu = rightClickMenu
        self.notificationCenter = notificationCenter
        image = NSImage(named: "Status Bar Image")!.imageApplyingTintColor(NSColor.white)!

        super.init(frame: Constant.frame)

        setupBindings()
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

// MARK: - Click handling

extension StatusItemView {
    override func mouseDown(with theEvent: NSEvent) {
        mouseDown = true
    }

    override func mouseUp(with theEvent: NSEvent) {
        guard mouseDown == true else { return }

        theEvent.modifierFlags.contains(.control) ? showMenu() : showMainView()

        mouseDown = false
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        mouseDown = true
    }

    override func rightMouseUp(with theEvent: NSEvent) {
        guard mouseDown == true else { return }

        showMenu()

        mouseDown = false
    }
}

// MARK: - Menu handling

fileprivate extension StatusItemView {
    func showMenu() {
        let token1 = notificationCenter.addObserver(forName: .NSMenuDidBeginTracking, object: rightClickMenu) { [weak self] _ in
            self?.makeMenuVisible()
        }

        let token2 = notificationCenter.addObserver(forName: .NSMenuDidEndTracking, object: rightClickMenu) { [weak self] _ in
            self?.makeMenuVisible()
        }

        notificationTokens = [token1, token2]

        statusItem.popUpMenu(rightClickMenu)
    }

    func showMainView() {
        _event.onNext(.toggleMainView(self))
    }

    func makeMenuVisible() {
        menuVisible = true

        notificationTokens?.forEach { (token) in
            self.notificationCenter.remove(observer: token)
        }
    }
}


// MARK: - Setup

fileprivate extension StatusItemView {
    func setupBindings() {
        rightClickMenu.itemSelected
            .map { option in
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
}

// MARK: - Event

extension StatusItemView {
    enum Event: Equatable {
        case toggleMainView(NSView)
        case openSettings
        case quit
    }
}

extension StatusItemView.Event {
    static func ==(lhs: StatusItemView.Event, rhs: StatusItemView.Event) -> Bool {
        switch (lhs, rhs) {
        case (.toggleMainView, .toggleMainView):
            return true
        case (.openSettings, .openSettings):
            return true
        case (.quit, .quit):
            return true
        default:
            return false
        }
    }
}

// MARK: - Constant

fileprivate extension StatusItemView {
    enum Constant {
        static let frame = NSRect(x: 0.0, y: 0.0, width: 30.0, height: NSStatusBar.system().thickness)
    }
}

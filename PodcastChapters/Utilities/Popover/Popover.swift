//
//  Popover.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class Popover: NSWindowController {

    var content: NSViewController? {
        get {
            return contentViewController
        }
        set(viewController) {
            contentViewController = nil
            contentViewController = viewController

            updateWindowFrame()
        }
    }

    private let animator: PopoverAnimator
    private let topMargin = 2.0
    private var presentedFrom: NSRect?

    init(popoverWindow: PopoverWindow = PopoverWindow.window(), animator: PopoverAnimator = PopoverAnimator()) {
        self.animator = animator

        super.init(window: popoverWindow)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Popover {

    func showFromView(view: NSView) {
        guard let window = window, frame = view.window?.frame else {
            return
        }

        presentedFrom = frame
        updateWindowFrame()

        window.alphaValue = 0.0
        NSApp.activateIgnoringOtherApps(true)
        showWindow(nil)

        animator.animateWindow(window, direction: .In) { direction in
            self.animationDidFinishInDirection(direction, forWindow: window)
        }
    }

    func dismiss() {
        guard let window = window else {
            return
        }

        animator.animateWindow(window, direction: .Out) { direction in
            self.animationDidFinishInDirection(direction, forWindow: window)
        }
    }
}

private extension Popover {

    func updateWindowFrame() {
        guard let window = window, anchorFrame = presentedFrom else {
            return
        }

        let frame = NSRect(
            x: anchorFrame.midX - window.frame.width / 2.0,
            y: anchorFrame.minY - window.frame.height - CGFloat(topMargin),
            width: window.frame.width,
            height: window.frame.height
        )
        
        window.setFrame(frame, display: true)
        window.appearance = NSAppearance.currentAppearance()
    }

    func animationDidFinishInDirection(direction: PopoverAnimationDirection, forWindow window: NSWindow) {
        switch direction {
        case .In:
            window.makeKeyWindow()
        case .Out:
            window.orderOut(self)
            window.close()
        }
    }
}

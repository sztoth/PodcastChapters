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
        get { return contentViewController }
        set {
            contentViewController = nil
            contentViewController = newValue

            updateWindowFrame()
        }
    }

    fileprivate let animator: PopoverAnimator
    fileprivate let topMargin = 2.0

    fileprivate var presentedFrom: NSRect?

    init(popoverWindow: PopoverWindow = PopoverWindow.window(), animator: PopoverAnimator = PopoverAnimator()) {
        self.animator = animator

        super.init(window: popoverWindow)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Show / hide

extension Popover {
    func show(from view: NSView) {
        guard let window = window, let frame = view.window?.frame else { return }

        presentedFrom = frame
        updateWindowFrame()

        window.alphaValue = 0.0
        NSApp.activate(ignoringOtherApps: true)
        showWindow(nil)

        animator.animate(window, direction: .in) { direction in
            self.animationDidFinish(in: direction, forWindow: window)
        }
    }

    func hide() {
        guard let window = window else { return }

        animator.animate(window, direction: .out) { direction in
            self.animationDidFinish(in: direction, forWindow: window)
        }
    }
}

// MARK: - Private

fileprivate extension Popover {
    func updateWindowFrame() {
        guard let window = window, let anchorFrame = presentedFrom else { return }

        let frame = NSRect(
            x: anchorFrame.midX - window.frame.width / 2.0,
            y: anchorFrame.minY - window.frame.height - CGFloat(topMargin),
            width: window.frame.width,
            height: window.frame.height
        )
        
        window.setFrame(frame, display: true)
        window.appearance = NSAppearance.current()
    }

    func animationDidFinish(in direction: PopoverAnimator.AnimationDirection, forWindow window: NSWindow) {
        switch direction {
        case .in:
            window.makeKey()
        case .out:
            window.orderOut(self)
            window.close()
        }
    }
}

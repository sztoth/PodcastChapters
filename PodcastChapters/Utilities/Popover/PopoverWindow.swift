//
//  PopoverWindow.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class PopoverWindow: NSPanel {
    var arrowHeight: Double {
        return backgroundView?.arrowHeight ?? 0.0
    }

    var cornerRadius: Double {
        return backgroundView?.cornerRadius ?? 0.0
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var contentView: NSView? {
        get { return windowContentView }
        set { setWindowContent(to: newValue) }
    }

    fileprivate var windowContentView: NSView?
    fileprivate var backgroundView: PopoverBackgroundView?

    // codebeat:disable[ARITY]
    fileprivate override init(contentRect: NSRect, styleMask aStyle: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)

        isOpaque = false
        hasShadow = true
        level = Int(CGWindowLevelForKey(.statusWindow))
        backgroundColor = NSColor.clear
        collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]
        appearance = NSAppearance.current()
    }
    // codebeat:enable[ARITY]

    override func frameRect(forContentRect contentRect: NSRect) -> NSRect {
        let height = contentRect.height + CGFloat(arrowHeight)
        return NSRect(x: contentRect.minX, y: contentRect.minY, width: contentRect.width, height: height)
    }
}

// MARK: - Default creation

extension PopoverWindow {
    class func window() -> PopoverWindow {
        return PopoverWindow(contentRect: NSRect.zero, styleMask: NSNonactivatingPanelMask, backing: .buffered, defer: true)
    }
}

// MARK: - Private

fileprivate extension PopoverWindow {
    func setWindowContent(to view: NSView?) {
        guard windowContentView != view else { return }

        let bounds = windowContentView?.bounds ?? NSRect.zero

        if !(super.contentView is PopoverBackgroundView) {
            backgroundView = PopoverBackgroundView(frame: bounds)
            super.contentView = backgroundView
        }

        if let windowContentView = windowContentView {
            windowContentView.removeFromSuperview()
        }

        if let view = view, let backgroundView = backgroundView {
            view.pch_roundCorners(cornerRadius)
            view.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(view)
            windowContentView = view

            let margin = 1.0

            view.topAnchor.pch_equal(to: backgroundView.topAnchor, constant: arrowHeight + margin)
            view.bottomAnchor.pch_equal(to: backgroundView.bottomAnchor, constant: -margin)
            view.leadingAnchor.pch_equal(to: backgroundView.leadingAnchor, constant: margin)
            view.trailingAnchor.pch_equal(to: backgroundView.trailingAnchor, constant: -margin)
        }
    }
}

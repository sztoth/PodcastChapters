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

    override var canBecomeKeyWindow: Bool {
        return true
    }

    override var contentView: NSView? {
        get {
            return windowContentView
        }
        set(view) {
            setWindowContentView(view)
        }
    }

    private var windowContentView: NSView?
    private var backgroundView: PopoverBackgroundView?

    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)

        opaque = false
        hasShadow = true
        level = Int(CGWindowLevelForKey(.StatusWindowLevelKey))
        backgroundColor = NSColor.clearColor()
        collectionBehavior = [.CanJoinAllSpaces, .IgnoresCycle]
        appearance = NSAppearance.currentAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frameRectForContentRect(contentRect: NSRect) -> NSRect {
        let height = contentRect.height + CGFloat(arrowHeight)
        return NSRect(x: contentRect.minX, y: contentRect.minY, width: contentRect.width, height: height)
    }
}

extension PopoverWindow {

    class func window() -> PopoverWindow {
        return PopoverWindow(contentRect: NSRect.zero, styleMask: NSNonactivatingPanelMask, backing: .Buffered, `defer`: true)
    }
}

private extension PopoverWindow {

    func setWindowContentView(view: NSView?) {
        if windowController == view {
            return
        }

        let bounds = windowContentView?.bounds ?? NSRect.zero

        if !(super.contentView is PopoverBackgroundView) {
            backgroundView = PopoverBackgroundView(frame: bounds)
            super.contentView = backgroundView
        }

        if let windowContentView = windowContentView {
            windowContentView.removeFromSuperview()
        }

        if let view = view, backgroundView = backgroundView {
            view.pch_roundCorners(cornerRadius)
            view.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(view)
            windowContentView = view

            let margin = 1.0

            view.topAnchor.pch_equalToAnchor(backgroundView.topAnchor, constant: arrowHeight + margin)
            view.bottomAnchor.pch_equalToAnchor(backgroundView.bottomAnchor, constant: -margin)
            view.leadingAnchor.pch_equalToAnchor(backgroundView.leadingAnchor, constant: margin)
            view.trailingAnchor.pch_equalToAnchor(backgroundView.trailingAnchor, constant: -margin)
        }
    }
}

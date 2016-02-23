//
//  PopoverWindow.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class PopoverWindow: NSPanel {

    private let arrowHeight = 10.0
    private let cornerRadius = 10.0
    private let margin = 1.0
    private var windowContentView: NSView?
    private var backgroundView: PopoverBackgroundView?

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

    class func window() -> PopoverWindow {
        return PopoverWindow(contentRect: NSRect.zero, styleMask: NSNonactivatingPanelMask, backing: .Buffered, `defer`: true)
    }

    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)

        self.opaque = false
        self.hasShadow = true
        self.level = Int(CGWindowLevelForKey(.StatusWindowLevelKey))
        self.backgroundColor = NSColor.clearColor()
        self.collectionBehavior = [.CanJoinAllSpaces, .IgnoresCycle]
        self.appearance = NSAppearance.currentAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func frameRectForContentRect(contentRect: NSRect) -> NSRect {
        return NSRect(x: contentRect.minX, y: contentRect.minY, width: contentRect.width, height: contentRect.height + CGFloat(arrowHeight))
    }
}

private extension PopoverWindow {

    func setWindowContentView(view: NSView?) {
        if windowController == view {
            return
        }

        let bounds = windowContentView?.bounds ?? NSRect.zero

        if !(super.contentView is PopoverBackgroundView) {
            let bgView = PopoverBackgroundView(frame: bounds, arrowHeight: arrowHeight, cornerRadius: cornerRadius)
            super.contentView = bgView
            backgroundView = bgView
        }

        if let windowContentView = windowContentView {
            windowContentView.removeFromSuperview()
        }

        if let view = view, backgroundView = backgroundView {
            view.pch_roundCorners(cornerRadius)
            view.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(view)
            windowContentView = view

            view.topAnchor.pch_equalToAnchor(backgroundView.topAnchor, constant: arrowHeight + margin)
            view.bottomAnchor.pch_equalToAnchor(backgroundView.bottomAnchor, constant: -margin)
            view.leadingAnchor.pch_equalToAnchor(backgroundView.leadingAnchor, constant: margin)
            view.trailingAnchor.pch_equalToAnchor(backgroundView.trailingAnchor, constant: -margin)
        }
    }
}

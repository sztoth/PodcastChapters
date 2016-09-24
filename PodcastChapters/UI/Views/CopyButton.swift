//
//  CopyButton.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class CopyButton: NSButton {

    fileprivate let icon = NSImage(named: "Copy Button Image")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        internalSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        internalSetup()
    }

    override func draw(_ dirtyRect: NSRect) {
        let mouseDownFlags = cell?.mouseDownFlags ?? 0
        let bgColor = mouseDownFlags == 0 ? ColorSettings.normalActionColor : ColorSettings.highlightedActionColor
        bgColor.set()

        let xRadius = floor(dirtyRect.width / 2.0)
        let yRadius = floor(dirtyRect.height / 2.0)
        let backgroundPath = NSBezierPath(roundedRect: dirtyRect, xRadius: xRadius, yRadius: yRadius)
        backgroundPath.fill()

        if let icon = icon {
            let ratio: CGFloat = 3.0 / 5.0
            let width = floor(dirtyRect.width * ratio)
            let height = floor(dirtyRect.height * ratio)
            let xOffset = floor((dirtyRect.width - width) / 2.0) + 1.0
            let yOffset = floor((dirtyRect.height - width) / 2.0) - 1.0
            let imageRect = NSRect(x: xOffset, y: yOffset, width: width, height: height)
            icon.draw(
                in: imageRect,
                from: .zero,
                operation: .sourceOver,
                fraction: 1.0,
                respectFlipped: true,
                hints: nil
            )
        }
    }
}

private extension CopyButton {

    func internalSetup() {
        setButtonType(.momentaryLight)
    }
}

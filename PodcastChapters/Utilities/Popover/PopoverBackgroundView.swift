//
//  PopoverBackgroundView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class PopoverBackgroundView: NSView {
    var arrowHeight = 10.0
    var arrowWidth = 42.0
    var cornerRadius = 10.0

    override var frame: NSRect {
        didSet { needsDisplay = true }
    }

    override init(frame: CGRect){
        super.init(frame: frame)

        internalSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        internalSetup()
    }

    override func draw(_ dirtyRect: NSRect) {
        var bgFrame = bounds
        bgFrame.size.height -= CGFloat(arrowHeight)
        let bgFrameHalfWidth = bgFrame.width / 2.0
        let arrowHalfWidth = arrowWidth / 2.0

        let arrow = NSBezierPath()

        let leftPoint = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowHalfWidth), y: bgFrame.maxY)
        arrow.move(to: leftPoint)

        let topPoint = NSPoint(x: bgFrameHalfWidth, y: bgFrame.maxY + CGFloat(arrowHeight))
        let topCP1 = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowWidth) / 4.0, y: bgFrame.maxY)
        let topCP2 = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowWidth) / 7.0, y: bgFrame.maxY + CGFloat(arrowHeight))
        arrow.curve(to: topPoint, controlPoint1: topCP1, controlPoint2: topCP2)

        let rightPoint = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowHalfWidth), y: bgFrame.maxY)
        let rightCP1 = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowWidth) / 7.0, y: bgFrame.maxY + CGFloat(arrowHeight))
        let rightCP2 = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowWidth) / 4.0, y: bgFrame.maxY)
        arrow.curve(to: rightPoint, controlPoint1: rightCP1, controlPoint2: rightCP2)

        arrow.line(to: leftPoint)
        arrow.close()

        let background = NSBezierPath(roundedRect: bgFrame, xRadius: CGFloat(cornerRadius), yRadius: CGFloat(cornerRadius))

        let window = NSBezierPath()
        window.append(arrow)
        window.append(background)

        ColorSettings.mainBackgroundColor.setFill()
        window.fill()
    }
}

// MARK: - Setup

fileprivate extension PopoverBackgroundView {
    func internalSetup() {
        pch_roundCorners(cornerRadius)
    }
}

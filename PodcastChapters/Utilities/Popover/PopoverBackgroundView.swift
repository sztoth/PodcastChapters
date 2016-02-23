//
//  PopoverBackgroundView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class PopoverBackgroundView: NSView {

    private let arrowHeight: Double
    private let arrowWidth: Double
    private let cornerRadius: Double
    private let fillColor: NSColor

    override var frame: NSRect {
        didSet {
            needsDisplay = true
        }
    }

    init(
        frame: CGRect,
        arrowHeight: Double = 11.0,
        arrowWidth: Double = 42.0,
        cornerRadius: Double = 5.0,
        fillColor: NSColor = NSColor.windowBackgroundColor()
    ){
        self.arrowHeight = arrowHeight
        self.arrowWidth = arrowWidth
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor

        super.init(frame: frame)

        pch_roundCorners(cornerRadius)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(dirtyRect: NSRect) {
        var bgFrame = bounds
        bgFrame.size.height -= CGFloat(arrowHeight)
        let bgFrameHalfWidth = bgFrame.width / 2.0
        let arrowHalfWidth = arrowWidth / 2.0

        let arrow = NSBezierPath()

        let leftPoint = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowHalfWidth), y: bgFrame.maxY)
        arrow.moveToPoint(leftPoint)

        let topPoint = NSPoint(x: bgFrameHalfWidth, y: bgFrame.maxY + CGFloat(arrowHeight))
        let topCP1 = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowWidth) / 4.0, y: bgFrame.maxY)
        let topCP2 = NSPoint(x: bgFrameHalfWidth - CGFloat(arrowWidth) / 7.0, y: bgFrame.maxY + CGFloat(arrowHeight))
        arrow.curveToPoint(topPoint, controlPoint1: topCP1, controlPoint2: topCP2)

        let rightPoint = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowHalfWidth), y: bgFrame.maxY)
        let rightCP1 = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowWidth) / 7.0, y: bgFrame.maxY + CGFloat(arrowHeight))
        let rightCP2 = NSPoint(x: bgFrameHalfWidth + CGFloat(arrowWidth) / 4.0, y: bgFrame.maxY)
        arrow.curveToPoint(rightPoint, controlPoint1: rightCP1, controlPoint2: rightCP2)

        arrow.lineToPoint(leftPoint)
        arrow.closePath()

        let background = NSBezierPath(roundedRect: bgFrame, xRadius: CGFloat(cornerRadius), yRadius: CGFloat(cornerRadius))

        let window = NSBezierPath()
        window.appendBezierPath(arrow)
        window.appendBezierPath(background)

        fillColor.setFill()
        window.fill()
    }
}

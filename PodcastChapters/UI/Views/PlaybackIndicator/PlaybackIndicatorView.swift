//
//  PlaybackIndicatorView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

enum PlaybackIndicatorState {
    case Stopped
    case Playing
}

class PlaybackIndicatorView: NSView {

    var state = PlaybackIndicatorState.Stopped {
        didSet {
            switch state {
            case .Stopped:
                stopAnimation()
            case .Playing:
                startAnimation()
            }
        }
    }

    override var intrinsicContentSize: NSSize {
        var tmpFrame = CGRect.zero
        bars.forEach { bar in
            tmpFrame = CGRectUnion(tmpFrame, bar.frame)
        }

        return tmpFrame.size
    }

    private var bars = [PlaybackIndicatorBarLayer]()
    private var installedConstraints = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false

        setupLayoutPriorities()
        createBars()

        needsUpdateConstraints = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !installedConstraints {
            let size = intrinsicContentSize
            widthAnchor.constraintEqualToConstant(size.width).active = true
            heightAnchor.constraintEqualToConstant(size.height).active = true

            installedConstraints = true
        }

        super.updateConstraints()
    }
}

private extension PlaybackIndicatorView {

    func setupLayoutPriorities() {
        setContentHuggingPriority(NSLayoutPriorityDefaultHigh, forOrientation: .Horizontal)
        setContentHuggingPriority(NSLayoutPriorityDefaultHigh, forOrientation: .Vertical)

        setContentCompressionResistancePriority(NSLayoutPriorityDefaultHigh, forOrientation: .Horizontal)
        setContentCompressionResistancePriority(NSLayoutPriorityDefaultHigh, forOrientation: .Vertical)
    }

    func createBars() {
        var xOffset = 0.0

        3.times { _ in
            let bar = PlaybackIndicatorBarLayer()
            bar.xOffset = xOffset

            bars.append(bar)
            layer!.addSublayer(bar)

            xOffset = Double(bar.frame.maxX) + 2.0
        }
    }

    func startAnimation() {
        bars.forEach { bar in
            bar.startAnimation()
        }
    }

    func stopAnimation() {
        bars.forEach { bar in
            bar.stopAnimation()
        }
    }
}

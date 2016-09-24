//
//  PlaybackIndicatorView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

enum PlaybackIndicatorState {
    case stopped
    case playing
}

class PlaybackIndicatorView: NSView {

    var state = PlaybackIndicatorState.stopped {
        didSet {
            switch state {
            case .stopped:
                stopAnimation()
            case .playing:
                startAnimation()
            }
        }
    }

    override var intrinsicContentSize: NSSize {
        var tmpFrame = CGRect.zero
        bars.forEach { bar in
            tmpFrame = tmpFrame.union(bar.frame)
        }

        return tmpFrame.size
    }

    fileprivate var bars = [PlaybackIndicatorBarLayer]()
    fileprivate var installedConstraints = false

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
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            heightAnchor.constraint(equalToConstant: size.height).isActive = true

            installedConstraints = true
        }

        super.updateConstraints()
    }
}

private extension PlaybackIndicatorView {

    func setupLayoutPriorities() {
        setContentHuggingPriority(NSLayoutPriorityDefaultHigh, for: .horizontal)
        setContentHuggingPriority(NSLayoutPriorityDefaultHigh, for: .vertical)

        setContentCompressionResistancePriority(NSLayoutPriorityDefaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(NSLayoutPriorityDefaultHigh, for: .vertical)
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

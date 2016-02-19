//
//  PopoverAnimator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias PopoverAnimationCompletion = (PopoverAnimationDirection) -> ()

enum PopoverAnimationDirection {
    case In
    case Out
}

class PopoverAnimator {

    private(set) var animating = false

    private let duration = 0.21
    private let distance = 8.0
    private let timingFunction = CAMediaTimingFunction.EaseInEaseOut
}

extension PopoverAnimator {

    func animateWindow(window: NSWindow, direction: PopoverAnimationDirection, completion: PopoverAnimationCompletion) {
        guard !animating else {
            return
        }

        animating = true

        var calculatedFrame = window.frame
        calculatedFrame.origin.y += CGFloat(distance)

        let alpha: Double
        let startFrame, endFrame: NSRect
        switch direction {
        case .In:
            alpha = 1.0
            startFrame = calculatedFrame
            endFrame = window.frame
        case .Out:
            alpha = 0.0
            startFrame = window.frame
            endFrame = calculatedFrame
        }

        window.setFrame(startFrame, display: true)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = self.duration
            context.timingFunction = self.timingFunction

            let animator = window.animator()
            animator.setFrame(endFrame, display: false)
            animator.alphaValue = CGFloat(alpha)
        }, completionHandler: { _ in
            self.animating = false
            completion(direction)
        })
    }
}

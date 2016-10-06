//
//  PopoverAnimator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

typealias PopoverAnimationCompletion = (PopoverAnimationDirection) -> ()

enum PopoverAnimationDirection {
    case `in`
    case out
}

class PopoverAnimator {

    fileprivate(set) var animating = false
}

extension PopoverAnimator {

    func animateWindow(_ window: NSWindow, direction: PopoverAnimationDirection, completion: @escaping PopoverAnimationCompletion) {
        guard !animating else {
            return
        }

        animating = true

        var calculatedFrame = window.frame
        calculatedFrame.origin.y += CGFloat(AnimationSettings.distance)

        let alpha: Double
        let startFrame, endFrame: NSRect
        switch direction {
        case .in:
            alpha = 1.0
            startFrame = calculatedFrame
            endFrame = window.frame
        case .out:
            alpha = 0.0
            startFrame = window.frame
            endFrame = calculatedFrame
        }

        window.setFrame(startFrame, display: true)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = AnimationSettings.duration
            context.timingFunction = AnimationSettings.timing

            let animator = window.animator()
            animator.setFrame(endFrame, display: false)
            animator.alphaValue = CGFloat(alpha)
        }, completionHandler: { _ in
            self.animating = false
            completion(direction)
        })
    }
}

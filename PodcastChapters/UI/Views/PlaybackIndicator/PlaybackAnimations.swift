//
//  PlaybackAnimations.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 08..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias PlaybackAnimationCompletion = () -> ()

protocol AnimationProvider {
    func build() -> CABasicAnimation
}

class PlaybackMovingAnimation {

    var duration = 0.0
    var fromCGRect = CGRect.zero
    var toCGRect = CGRect.zero

    fileprivate var animation: CABasicAnimation

    init(completion: PlaybackAnimationCompletion?) {
        animation = CABasicAnimation(keyPath: "bounds")
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction.EaseIn

        let animationDelegate = AnimationDelegate()
        animationDelegate.completion = completion

        // TODO:
        //animation.delegate = animationDelegate
    }
}

extension PlaybackMovingAnimation: AnimationProvider {

    func build() -> CABasicAnimation {
        animation.duration = duration
        animation.fromValue = NSValue(rect: fromCGRect)
        animation.toValue = NSValue(rect: toCGRect)

        return animation
    }
}

class PlaybackDecayAnimation {

    var fromCGRect = CGRect.zero
    var toCGRect = CGRect.zero

    fileprivate var animation: CABasicAnimation

    init() {
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction.EaseOut
    }
}

extension PlaybackDecayAnimation: AnimationProvider {

    func build() -> CABasicAnimation {
        animation.fromValue = NSValue(rect: fromCGRect)
        animation.toValue = NSValue(rect: toCGRect)

        return animation
    }
}

private class AnimationDelegate: NSObject {
    var completion: PlaybackAnimationCompletion?
    var active = true

    // TODO:
//    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if active {
//            completion?()
//        }
//    }
}

extension CAAnimation {

    func cancel() {
        if let delegate = delegate as? AnimationDelegate {
            delegate.active = false
        }
    }
}

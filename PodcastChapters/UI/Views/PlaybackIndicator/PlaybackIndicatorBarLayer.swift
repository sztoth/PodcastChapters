//
//  PlaybackIndicatorBarLayer.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class PlaybackIndicatorBarLayer: CALayer {

    var xOffset: Double {
        get {
            return Double(position.x)
        }
        set(offset) {
            let point = CGPoint(x: offset, y: Settings.MaxHeight)
            position = point
        }
    }

    var isAnimating: Bool {
        let animation = self.animation(forKey: Settings.MovingAnimationKey)
        return animation != nil
    }

    fileprivate struct Settings {
        static let MovingAnimationKey = "MovingAnimation"
        static let DecayAnimationKey = "DecayAnimation"
        static let MinHeight = 3.0
        static let MaxHeight = 12.0
        static let Width = 3.0
    }

    override init(layer: Any) {
        super.init(layer: layer)

        if let layer = layer as? CALayer {
            position = layer.position
            bounds = layer.bounds
        }
        else {
            position = CGPoint.zero
            bounds = CGRect.zero
        }

    }

    override init() {
        super.init()

        internalSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        internalSetup()
    }
}

extension PlaybackIndicatorBarLayer {

    func startAnimation() {
        guard !isAnimating else {
            return
        }

        stopAnimationForKey(Settings.DecayAnimationKey)
        addMovingAnimation()
    }

    func stopAnimation() {
        guard isAnimating else {
            return
        }

        stopAnimationForKey(Settings.MovingAnimationKey)
        addDecayAnimation()
    }
}

private extension PlaybackIndicatorBarLayer {

    func internalSetup() {
        anchorPoint = CGPoint(x: 0.0, y: 1.0)
        bounds = CGRect(x: 0.0, y: 0.0, width: Settings.Width, height: Settings.MinHeight)
        backgroundColor = ColorSettings.equalizerColor.cgColor
    }

    func addMovingAnimation() {
        let minHeight = Settings.MinHeight
        let maxHeight = Settings.MaxHeight

        let peakHeight = Double(UInt32(minHeight) + arc4random_uniform(UInt32(maxHeight - minHeight + 1.0)))
        let basePeriod = 0.6 + (drand48() * (0.8 - 0.6));
        let duration = (basePeriod / 2.0) * (maxHeight / peakHeight)
        var toValue = bounds
        toValue.size.height = CGFloat(maxHeight)

        let animation = PlaybackMovingAnimation {
            self.addMovingAnimation()
        }
        animation.duration = duration
        animation.fromCGRect = bounds
        animation.toCGRect = toValue

        add(animation.build(), forKey: Settings.MovingAnimationKey)
    }

    func addDecayAnimation() {
        let fromValue = (presentation() as? CALayer)?.bounds ?? CGRect.zero

        let animation = PlaybackDecayAnimation()
        animation.fromCGRect = fromValue
        animation.toCGRect = bounds

        add(animation.build(), forKey: Settings.DecayAnimationKey)
    }

    func stopAnimationForKey(_ key: String) {
        if let animation = animation(forKey: key) {
            animation.cancel()
        }

        removeAnimation(forKey: key)
    }
}

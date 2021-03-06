//
//  NSTimer+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias TimerAction = () -> ()

extension Foundation.Timer {
    static func pch_scheduledTimer(with timeInterval: TimeInterval, repeats: Bool, action: @escaping TimerAction) -> Foundation.Timer {
        let timer = Foundation.Timer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(pch_timerFired(_:)),
            userInfo: TimerData(repeats: repeats, action: action),
            repeats: repeats)

        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)

        return timer
    }
}

fileprivate extension Foundation.Timer {
    @objc static func pch_timerFired(_ timer: Foundation.Timer) {
        guard let container = timer.userInfo as? TimerData else { return }

        container.action()

        if !container.repeats {
            timer.invalidate()
        }
    }
}

fileprivate class TimerData: NSObject {
    let repeats: Bool
    let action: TimerAction

    init(repeats: Bool, action: @escaping TimerAction) {
        self.repeats = repeats
        self.action = action

        super.init()
    }
}

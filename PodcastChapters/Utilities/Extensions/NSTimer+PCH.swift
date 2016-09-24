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

    class func pch_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, repeats: Bool, action: @escaping TimerAction) -> Foundation.Timer {
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

private extension Foundation.Timer {

    class TimerData: NSObject {
        
        fileprivate let repeats: Bool
        fileprivate let action: TimerAction

        init(repeats: Bool, action: @escaping TimerAction) {
            self.repeats = repeats
            self.action = action

            super.init()
        }
    }

    @objc class func pch_timerFired(_ timer: Foundation.Timer) {
        if let container = timer.userInfo as? TimerData {
            container.action()

            if !container.repeats {
                timer.invalidate()
            }
        }
    }
}

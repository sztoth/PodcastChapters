//
//  NSTimer+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias TimerAction = () -> ()

extension NSTimer {

    class func pch_scheduledTimerWithTimeInterval(timeInterval: NSTimeInterval, repeats: Bool, action: TimerAction) -> NSTimer {
        let timer = NSTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(pch_timerFired(_:)),
            userInfo: TimerData(repeats: repeats, action: action),
            repeats: repeats)

        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

        return timer
    }
}

private extension NSTimer {

    class TimerData: NSObject {
        
        private let repeats: Bool
        private let action: TimerAction

        init(repeats: Bool, action: TimerAction) {
            self.repeats = repeats
            self.action = action

            super.init()
        }
    }

    @objc class func pch_timerFired(timer: NSTimer) {
        if let container = timer.userInfo as? TimerData {
            container.action()

            if !container.repeats {
                timer.invalidate()
            }
        }
    }
}
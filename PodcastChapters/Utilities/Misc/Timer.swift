//
//  Timer.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation


class Timer {

    private var timer: NSTimer?

    init(interval: NSTimeInterval, repeats: Bool = false, action: TimerAction) {
        timer = NSTimer.pch_scheduledTimerWithTimeInterval(interval, repeats: repeats, action: action)
    }

    deinit {
        cancel()
    }
}

extension Timer {

    func cancel() {
        timer?.invalidate()
    }
}

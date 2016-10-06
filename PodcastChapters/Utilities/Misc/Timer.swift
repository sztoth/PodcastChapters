//
//  Timer.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation


class Timer {

    fileprivate var timer: Foundation.Timer?

    init(interval: TimeInterval, repeats: Bool = false, action: @escaping TimerAction) {
        timer = Foundation.Timer.pch_scheduledTimerWithTimeInterval(interval, repeats: repeats, action: action)
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

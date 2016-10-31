//
//  PlayerState+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 31..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension PlayerState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .playing:
            return "Playing"
        case .paused:
            return "Paused"
        case .stopped:
            return "Stopped"
        }
    }
}

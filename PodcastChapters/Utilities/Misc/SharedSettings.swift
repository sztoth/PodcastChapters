//
//  SharedSettings.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

enum ColorSettings {
    static var mainBackgroundColor: NSColor {
        return darkBackgroundColor
    }

    static var subBackgroundColor: NSColor {
        return lightBackgroundColor
    }

    static var normalActionColor: NSColor {
        return greenishColor
    }

    static var highlightedActionColor: NSColor {
        return whiteColor
    }

    static var textColor: NSColor {
        return whiteColor
    }

    static var equalizerColor: NSColor {
        return pinkColor
    }

    static var cellSelectionColor: NSColor {
        return pinkColor
    }
}

fileprivate extension ColorSettings {
    static let darkBackgroundColor = try! NSColor(hexString: "#222831")
    static let lightBackgroundColor = try! NSColor(hexString: "#393E46")
    static let greenishColor = try! NSColor(hexString: "#00ADB5")
    static let whiteColor = try! NSColor(hexString: "#EEEEEE")
    static let pinkColor = try! NSColor(hexString: "#EA526F")
}

enum AnimationSettings {
    static let duration = 0.21
    static let distance = 8.0
    static let timing = CAMediaTimingFunction.EaseInEaseOut
}

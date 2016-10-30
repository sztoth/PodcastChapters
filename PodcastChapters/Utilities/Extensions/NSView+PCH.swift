//
//  NSView+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 19..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

protocol NibLoadable: class {
    static func pch_loadFromNib<T>(owner: NSObject?) -> T?
}

extension NSView: NibLoadable {
    static func pch_loadFromNib<T>(owner: NSObject? = nil) -> T? {
        guard let nib = NSNib(nibNamed: String(describing: self), bundle: nil) else { return nil }

        var topLevelObjects: NSArray? = []
        guard nib.instantiate(withOwner: owner, topLevelObjects: &topLevelObjects!) == true else { return nil }

        guard let item = topLevelObjects?.filter({ $0 is T }).first else { return nil }

        return item as? T
    }
}

extension NSView {
    func pch_roundCorners(_ radious: Double) {
        wantsLayer = true
        layer?.cornerRadius = CGFloat(radious)
        layer?.masksToBounds = true
        layer?.edgeAntialiasingMask = [.layerTopEdge, .layerLeftEdge, .layerRightEdge, .layerBottomEdge]
    }
}

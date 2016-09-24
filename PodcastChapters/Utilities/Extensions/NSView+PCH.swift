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
        if let nib = NSNib(nibNamed: String(describing: self), bundle: nil) {
            var topLevelObjects: NSArray?
            if nib.instantiate(withOwner: owner, topLevelObjects: &topLevelObjects!) == true {
                if let objects = topLevelObjects {
                    let items = objects.filter { element in
                        element is T
                    }

                    if let item = items.first {
                        return item as? T
                    }
                }
            }
        }

        return nil
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

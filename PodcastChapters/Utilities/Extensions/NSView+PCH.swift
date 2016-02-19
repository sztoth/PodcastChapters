//
//  NSView+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 19..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

protocol NibLoadable: class {

    static func loadFromNib<T>() -> T?
}

extension NSView: NibLoadable {

    static func loadFromNib<T>() -> T? {
        if let nib = NSNib(nibNamed: String(self), bundle: nil) {
            var topLevelObjects: NSArray?
            if nib.instantiateWithOwner(nil, topLevelObjects: &topLevelObjects) == true {
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

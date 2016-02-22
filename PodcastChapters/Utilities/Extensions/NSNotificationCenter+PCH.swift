//
//  NSNotificationCenter+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSNotificationCenter {

    class func pch_addObserverForName(name: String, object: AnyObject? = nil, usingBlock: (NSNotification) -> Void) {
        self.defaultCenter().addObserverForName(name, object: object, queue: nil, usingBlock: usingBlock)
    }

    class func pch_removeObserver(observer: AnyObject, name: String, object: AnyObject? = nil) {
        self.defaultCenter().removeObserver(observer, name: name, object: object)
    }
}
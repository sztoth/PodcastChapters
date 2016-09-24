//
//  NSNotificationCenter+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension Foundation.NotificationCenter {

    class func pch_addObserverForName(_ name: String, object: AnyObject? = nil, usingBlock: @escaping (Foundation.Notification) -> Void) {
        self.default.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: nil, using: usingBlock)
    }

    class func pch_removeObserver(_ observer: AnyObject, name: String, object: AnyObject? = nil) {
        self.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
}

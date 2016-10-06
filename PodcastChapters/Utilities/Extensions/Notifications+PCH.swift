//
//  NSNotificationCenter+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias NotificationBlock = (Foundation.Notification) -> Void

extension DistributedNotificationCenter {
    func pch_addObserver(forName name: NSNotification.Name?, using block: @escaping NotificationBlock) -> NSObjectProtocol {
        return addObserver(forName: name, object: nil, queue: nil, using: block)
    }
}

extension Foundation.NotificationCenter {
    static func pch_addObserverForName(_ name: String, object: AnyObject? = nil, usingBlock: @escaping NotificationBlock) {
        `default`.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: nil, using: usingBlock)
    }

    static func pch_removeObserver(_ observer: AnyObject, name: String, object: AnyObject? = nil) {
        `default`.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
}

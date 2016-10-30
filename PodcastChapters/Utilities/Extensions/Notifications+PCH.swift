//
//  NSNotificationCenter+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias NotificationBlock = (Notification) -> Void

protocol NotificationCenterType {
    func addObserver(forName name: NSNotification.Name, object: Any?, using block: @escaping NotificationBlock) -> NSObjectProtocol
    func addObserver(forName name: String, object: Any?, using block: @escaping NotificationBlock) -> NSObjectProtocol
    func remove(observer: NSObjectProtocol?)
}

extension NotificationCenterType {
    func addObserver(forName name: String, object: Any? = nil, using block: @escaping NotificationBlock) -> NSObjectProtocol {
        let notificationName = NSNotification.Name(rawValue: name)
        return addObserver(forName: notificationName, object: object, using: block)
    }
}

extension NotificationCenter: NotificationCenterType {
    func addObserver(forName name: NSNotification.Name, object: Any? = nil, using block: @escaping NotificationBlock) -> NSObjectProtocol {
        let token = addObserver(forName: name, object: object, queue: nil) { notification in
            block(notification)
        }

        return token
    }

    func remove(observer: NSObjectProtocol?) {
        guard let observer = observer else { return }
        removeObserver(observer)
    }
}

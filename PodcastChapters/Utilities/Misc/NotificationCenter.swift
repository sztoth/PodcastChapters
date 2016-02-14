//
//  NotificationCenter.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 13..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class NotificationCenter {

    static let sharedInstance = NotificationCenter()

    private init() {}

    func showMessage(message: String, image: NSImage?) {
        let notification = NSUserNotification()
        notification.title = "Next song"
        notification.informativeText = message
        notification.contentImage = image

        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
}
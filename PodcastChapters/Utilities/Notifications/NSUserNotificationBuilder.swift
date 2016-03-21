//
//  NSUserNotificationBuilder.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class NSUserNotificationBuilder {

    class func build(source: Notification) -> NSUserNotification {
        let notification = NSUserNotification()
        notification.identifier = source.identifier
        notification.title = source.title
        notification.informativeText = source.description
        notification.hasActionButton = true
        notification.actionButtonTitle = source.actionButtonTitle
        notification.otherButtonTitle = source.otherButtonTitle

        notification.setValue(source.image, forKey: "_identityImage")

        return notification
    }
}
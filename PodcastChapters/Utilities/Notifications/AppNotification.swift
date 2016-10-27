//
//  Notification.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

typealias AppNotificationAction = () -> ()

class AppNotification {
    let identifier: String
    let title: String
    let description: String
    let image: NSImage?
    let actionButtonTitle: String
    let otherButtonTitle: String
    let actionHandler: AppNotificationAction

    init(description: String, image: NSImage? = nil, actionHandler: @escaping AppNotificationAction) {
        self.description = description
        self.image = image
        self.actionHandler = actionHandler

        identifier = ""
        title = "Now playing"
        actionButtonTitle = "Copy"
        otherButtonTitle = "Close"
    }
}

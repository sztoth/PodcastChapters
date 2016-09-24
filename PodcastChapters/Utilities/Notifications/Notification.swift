//
//  Notification.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

typealias NotificationAction = () -> ()

class Notification {

    let identifier: String
    let title: String
    let description: String
    let image: NSImage?
    let actionButtonTitle: String
    let otherButtonTitle: String
    let actionHandler: NotificationAction

    init(description: String, image: NSImage? = nil, actionHandler: @escaping NotificationAction) {
        identifier = ""
        title = "Now playing"
        self.description = description
        self.image = image
        actionButtonTitle = "Copy"
        otherButtonTitle = "Close"
        self.actionHandler = actionHandler
    }
}

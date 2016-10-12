//
//  NSUserNotification.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSUserNotification {
    convenience init(appNotification: AppNotification) {
        self.init()

        identifier = appNotification.identifier
        title = appNotification.title
        informativeText = appNotification.description
        hasActionButton = true
        actionButtonTitle = appNotification.actionButtonTitle
        otherButtonTitle = appNotification.otherButtonTitle

        setValue(appNotification.image, forKey: "_identityImage")
    }
}

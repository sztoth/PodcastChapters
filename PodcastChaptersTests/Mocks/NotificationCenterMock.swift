//
//  NotificationCenterMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class NotificationCenterMock {
    fileprivate(set) var clearAllNotificationCalled = false
    fileprivate(set) var notificationToDeliver: PodcastChapters.Notification?
}

extension NotificationCenterMock: NotificationCenterType {
    func clearAllNotifications() {
        clearAllNotificationCalled = true
    }

    func deliverNotification(_ notification: PodcastChapters.Notification) {
        notificationToDeliver = notification
    }
}

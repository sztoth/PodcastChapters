//
//  NotificationCenterMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class AppNotificationCenterMock {
    fileprivate(set) var clearAllNotificationCalled = false
    fileprivate(set) var notificationToDeliver: AppNotification?
}

extension AppNotificationCenterMock: AppNotificationCenterType {
    func clearAllNotifications() {
        clearAllNotificationCalled = true
    }

    func deliver(_ notification: AppNotification) {
        notificationToDeliver = notification
    }
}

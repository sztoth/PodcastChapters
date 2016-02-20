//
//  NotificationCenter.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 13..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

class NotificationCenter: NSObject {

    static let sharedInstance = NotificationCenter()

    private let userNotificationCenter: NSUserNotificationCenter
    private var notifications = [Notification]()

    private init(userNotificationCenter: NSUserNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()) {
        self.userNotificationCenter = userNotificationCenter

        super.init()

        self.userNotificationCenter.delegate = self
    }
}

private extension NotificationCenter {

    func performActionWithIdentif(identifier: String?) {
        if let identifier = identifier, notification = notifications.filter({ $0.identifier == identifier }).first {
            notification.actionHandler()

            clearNotificationWithIdentifier(identifier)
        }
    }

    func clearNotificationWithIdentifier(identifier: String) {
        if let index = notifications.indexOf({ $0.identifier == identifier }) {
            notifications.removeAtIndex(index)
        }
    }
}

extension NotificationCenter {

    func clearAllNotifications() {
        userNotificationCenter.removeAllDeliveredNotifications()
        notifications.removeAll()
    }

    func deliverNotification(notification: Notification) {
        clearAllNotifications()

        let userNotification = NSUserNotificationBuilder.build(notification)
        notifications.append(notification)
        userNotificationCenter.deliverNotification(userNotification)
    }
}

extension NotificationCenter: NSUserNotificationCenterDelegate {

    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        if notification.activationType == .ActionButtonClicked {
            performActionWithIdentif(notification.identifier)
        }
    }
}
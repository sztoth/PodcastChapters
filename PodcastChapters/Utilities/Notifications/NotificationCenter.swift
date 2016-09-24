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

    fileprivate let userNotificationCenter: NSUserNotificationCenter
    fileprivate var notifications = [Notification]()
    fileprivate var timer: Timer?

    fileprivate init(userNotificationCenter: NSUserNotificationCenter = NSUserNotificationCenter.default) {
        self.userNotificationCenter = userNotificationCenter

        super.init()

        self.userNotificationCenter.delegate = self
    }
}

private extension NotificationCenter {

    func performActionWithIdentifier(_ identifier: String?) {
        if let identifier = identifier, let notification = notifications.filter({ $0.identifier == identifier }).first {
            notification.actionHandler()

            clearNotificationWithIdentifier(identifier)
        }
    }

    func clearNotificationWithIdentifier(_ identifier: String) {
        if let index = notifications.index(where: { $0.identifier == identifier }) {
            notifications.remove(at: index)
        }
    }
}

extension NotificationCenter {

    func clearAllNotifications() {
        timer = nil
        userNotificationCenter.removeAllDeliveredNotifications()
        notifications.removeAll()
    }

    func deliverNotification(_ notification: Notification) {
        clearAllNotifications()

        let userNotification = NSUserNotificationBuilder.build(notification)
        notifications.append(notification)
        userNotificationCenter.deliver(userNotification)

        timer = Timer(interval: 90.0) { [weak self] _ in
            self?.clearAllNotifications()
        }
    }
}

extension NotificationCenter: NSUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if notification.activationType == .actionButtonClicked {
            performActionWithIdentifier(notification.identifier)
        }
    }
}

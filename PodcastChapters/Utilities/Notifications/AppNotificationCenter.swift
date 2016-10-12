//
//  AppNotificationCenter.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 13..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

protocol AppNotificationCenterType {
    func clearAllNotifications()
    func deliverNotification(_ notification: AppNotification)
}

class AppNotificationCenter: NSObject {
    fileprivate let userNotificationCenter: NSUserNotificationCenter

    fileprivate var notifications = [AppNotification]()
    fileprivate var timer: Timer?

    init(userNotificationCenter: NSUserNotificationCenter = NSUserNotificationCenter.default) {
        self.userNotificationCenter = userNotificationCenter

        super.init()

        self.userNotificationCenter.delegate = self
    }
}

extension AppNotificationCenter: AppNotificationCenterType {
    func clearAllNotifications() {
        timer = nil
        userNotificationCenter.removeAllDeliveredNotifications()
        notifications.removeAll()
    }

    func deliverNotification(_ notification: AppNotification) {
        clearAllNotifications()

        notifications.append(notification)

        let userNotification = NSUserNotification(appNotification: notification)
        userNotificationCenter.deliver(userNotification)

        timer = Timer(interval: 90.0) { [weak self] _ in
            self?.clearAllNotifications()
        }
    }
}

fileprivate extension AppNotificationCenter {
    func performActionWithIdentifier(_ identifier: String) {
        guard let notification = notifications.filter({ $0.identifier == identifier }).first else { return }

        notification.actionHandler()
        clearNotificationWithIdentifier(identifier)
    }

    func clearNotificationWithIdentifier(_ identifier: String) {
        guard let index = notifications.index(where: { $0.identifier == identifier }) else { return }
        notifications.remove(at: index)
    }
}

extension AppNotificationCenter: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let identifier = notification.identifier else { return }

        if notification.activationType == .actionButtonClicked {
            performActionWithIdentifier(identifier)
        }
    }
}

//
//  DistributedNotificationCenterMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
@testable
import PodcastChapters

class DistributedNotificationCenterMock {
    fileprivate(set) var notificationName: String?
    fileprivate(set) var notificationBlock: NotificationBlock?
    fileprivate(set) var removedObserver: NSObjectProtocol?

    var returnedObserver: NSObjectProtocol?
}

extension DistributedNotificationCenterMock: NotificationCenterType {
    func addObserver(forName name: NSNotification.Name, object: Any?, using block: @escaping NotificationBlock) -> NSObjectProtocol {
        notificationName = name.rawValue
        notificationBlock = block

        if let returnedObserver = returnedObserver {
            return returnedObserver
        }

        let observer = NSString(string: "Observer")
        returnedObserver = observer
        return observer
    }

    func remove(observer: NSObjectProtocol?) {
        removedObserver = observer
    }
}

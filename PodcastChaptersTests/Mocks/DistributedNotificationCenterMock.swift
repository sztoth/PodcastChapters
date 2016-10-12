//
//  DistributedNotificationCenterMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class DistributedNotificationCenterMock {
    fileprivate(set) var notificationName: String?
    fileprivate(set) var notificationBlock: DistributedNotificationCenterBlock?
    fileprivate(set) var returnedObserver: NSObjectProtocol?
    fileprivate(set) var removedObserver: NSObjectProtocol?
}

extension DistributedNotificationCenterMock: DistributedNotificationCenterType {
    func addObserver(forName name: String, using block: @escaping DistributedNotificationCenterBlock) -> NSObjectProtocol {
        notificationName = name
        notificationBlock = block

        let observer = NSString(string: "Observer")
        returnedObserver = observer
        return observer
    }

    func remove(observer: NSObjectProtocol?) {
        removedObserver = observer
    }
}

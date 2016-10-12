//
//  DistributedNotificationCenter+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

typealias DistributedNotificationCenterBlock = () -> ()

protocol DistributedNotificationCenterType {
    func addObserver(forName name: String, using block: @escaping DistributedNotificationCenterBlock) -> NSObjectProtocol
    func remove(observer: NSObjectProtocol?)
}

extension DistributedNotificationCenter: DistributedNotificationCenterType {
    func addObserver(forName name: String, using block: @escaping DistributedNotificationCenterBlock) -> NSObjectProtocol {
        let notificationName = NSNotification.Name(rawValue: name)
        let token = addObserver(forName: notificationName, object: nil, queue: nil) { _ in
            block()
        }

        return token
    }

    func remove(observer: NSObjectProtocol?) {
        removeObserver(observer)
    }
}

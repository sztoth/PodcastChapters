//
//  NSDistributedNotificationCenter.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension DistributedNotificationCenter {
    func pch_addObserver(_ observer: AnyObject, selector aSelector: Selector, name aName: String?) {
        addObserver(observer, selector: aSelector, name: aName.map { NSNotification.Name(rawValue: $0) }, object: nil)
    }
}

//
//  StatusBarItemMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

@testable import PodcastChapters

class StatusBarItemMock: StatusBarItem {
    override var event: Observable<StatusBarItem.Event> {
        return eventSignal.asObservable()
    }

    let eventSignal = PublishSubject<StatusBarItem.Event>()
}

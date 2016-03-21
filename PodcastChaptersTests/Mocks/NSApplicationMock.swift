//
//  NSApplicationMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class NSApplicationMock: NSApplicationProtocol {

    enum ExecutedMethod {
        case Nothing, Terminate
    }

    private(set) var executedMethod = ExecutedMethod.Nothing

    func terminate(sender: AnyObject?) {
        executedMethod = .Terminate
    }
}
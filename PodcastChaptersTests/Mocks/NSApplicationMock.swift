//
//  NSApplicationMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
@testable
import PodcastChapters

class NSApplicationMock: NSApplicationType {
    fileprivate(set) var executedMethod = ExecutedMethod.nothing

    func terminate(_ sender: Any?) {
        executedMethod = .terminate
    }
}

extension NSApplicationMock {
    enum ExecutedMethod {
        case nothing
        case terminate
    }
}

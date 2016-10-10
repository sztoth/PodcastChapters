//
//  PopoverMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit

@testable import PodcastChapters

class PopoverMock: Popover {
    fileprivate(set) var executedMethod = ExecutedMethod.nothing
}

extension PopoverMock {
    override func showFrom(view: NSView) {
        executedMethod = .showFromView(view)
    }

    override func dismiss() {
        executedMethod = .dismiss
    }
}

extension PopoverMock {
    enum ExecutedMethod {
        case nothing
        case showFromView(NSView)
        case dismiss
    }
}

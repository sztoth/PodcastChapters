//
//  PopoverMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

@testable import PodcastChapters

class PopoverMock: Popover {

    enum ExecutedMethod {
        case nothing, showFromView(NSView), dismiss
    }

    fileprivate(set) var executedMethod = ExecutedMethod.nothing

    override func showFromView(_ view: NSView) {
        executedMethod = .showFromView(view)
    }

    override func dismiss() {
        executedMethod = .dismiss
    }
}

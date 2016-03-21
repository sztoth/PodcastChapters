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
        case Nothing, ShowFromView(NSView), Dismiss
    }

    private(set) var executedMethod = ExecutedMethod.Nothing

    override func showFromView(view: NSView) {
        executedMethod = .ShowFromView(view)
    }

    override func dismiss() {
        executedMethod = .Dismiss
    }
}

//
//  PasteBoardMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
@testable
import PodcastChapters

class PasteBoardMock {
    var copiedString: String?
}

extension PasteBoardMock: PasteBoardType {
    func copy(_ content: String) {
        copiedString = content
    }
}

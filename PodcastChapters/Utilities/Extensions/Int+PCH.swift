//
//  Int+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 08..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension Int {

    func times(@noescape closure: (Int) -> Void) {
        for index in 0..<self {
            closure(index)
        }
    }
}

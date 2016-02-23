//
//  NSLayoutConstraint.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 23..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSLayoutAnchor {

    func pch_equalToAnchor(anchor: NSLayoutAnchor, constant: Double) {
        constraintEqualToAnchor(anchor, constant: CGFloat(constant)).active = true
    }
}

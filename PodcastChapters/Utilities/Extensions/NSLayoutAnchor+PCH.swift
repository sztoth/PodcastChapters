//
//  NSLayoutConstraint.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 23..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

extension NSLayoutAnchor {

    func pch_equalToAnchor(_ anchor: NSLayoutAnchor, constant: Double = 0.0) {
        constraint(equalTo: anchor, constant: CGFloat(constant)).isActive = true
    }
}

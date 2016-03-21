//
//  CAMediaTimingFunction+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 16..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension CAMediaTimingFunction {

    @nonobjc static let EaseInEaseOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    @nonobjc static let EaseIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    @nonobjc static let EaseOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
}

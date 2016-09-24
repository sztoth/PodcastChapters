//
//  NSNumber+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSNumber {

    class func pch_numberFromHex(_ hex: String) -> NSNumber? {
        let scanner = Scanner(string: hex)

        var value: UInt64 = 0
        if scanner.scanHexInt64(&value) {
            return NSNumber(value: value as UInt64)
        }

        return nil
    }
}

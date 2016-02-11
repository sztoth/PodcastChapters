//
//  NSNumber+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSNumber {

    class func numberFromHex(hex: String) -> NSNumber? {
        let scanner = NSScanner(string: hex)

        var value: UInt64 = 0
        if scanner.scanHexLongLong(&value) {
            return NSNumber(unsignedLongLong: value)
        }

        return nil
    }
}

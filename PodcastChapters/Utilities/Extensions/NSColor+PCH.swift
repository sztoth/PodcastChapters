//
//  NSColor+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

enum NSColorHexConversionError: ErrorType {
    case ParameterNotScannable
    case InvalidCharacterCount
}

extension NSColor {

    convenience init(hexString: String) throws {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        if !NSScanner(string: hex).scanHexInt(&int) {
            throw NSColorHexConversionError.ParameterNotScannable
        }

        let a, r, g, b: UInt32

        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            throw NSColorHexConversionError.InvalidCharacterCount
        }

        let divider: CGFloat = 255.0
        let red = CGFloat(r) / divider
        let green = CGFloat(g) / divider
        let blue = CGFloat(b) / divider
        let alpha = CGFloat(a) / divider
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
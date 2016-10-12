//
//  NSImage+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 10..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

extension NSImage {
    static func pch_loadImage(named name: String, ofType type: String = "png") -> NSImage {
        let bundle = Bundle(for: iTunesMock.self)
        guard let path = bundle.path(forResource: name, ofType: type) else {
            fatalError("Could not find the \(name).\(type) in the test bundle")
        }

        return NSImage(contentsOfFile: path)!
    }
}

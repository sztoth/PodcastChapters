//
//  NSBundle+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension Bundle {

    class func pch_appName() -> String {
        let name = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        return name ?? "Unknown app"
    }

    class func pch_bundleIdentifier() -> String {
        let identifier = Bundle.main.bundleIdentifier
        return identifier ?? "Unknown identifier"
    }
}

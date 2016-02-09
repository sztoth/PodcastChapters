//
//  SBApplication+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ScriptingBridge

extension SBApplication {

    class func pch_iTunes() -> iTunesApplication {
        return SBApplication(bundleIdentifier: iTunesApp.BundleIdentifier) as! iTunesApplication
    }
}

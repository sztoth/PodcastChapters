//
//  main.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

fileprivate func delegateInstance() -> NSApplicationDelegate? {
    return NSClassFromString("XCTestCase") == nil ? AppDelegate() : nil
}

let delegate = AppDelegate()

let app = NSApplication.shared()
app.delegate = delegate
app.run()

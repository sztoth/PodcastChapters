//
//  main.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

private func delegateInstance() -> NSApplicationDelegate? {
    return NSClassFromString("XCTestCase") == nil ? AppDelegate() : nil
}

let delegate = delegateInstance()

let app = NSApplication.shared()
app.delegate = delegate
app.run()

//
//  NSRunningApplication.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

extension NSRunningApplication {
    static func pch_ensureThereIsOnlyOneRunnningInstance(with identifier: String = Bundle.pch_bundleIdentifier()) {
        let applications = runningApplications(withBundleIdentifier: identifier)
        if 1 < applications.count {
            let alert = MultipleInstanceAlert()
            alert.runModal()

            if let instance = applications.filter({ $0 != self.current() }).first {
                instance.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
            }

            NSApp.terminate(nil)
        }
    }
}

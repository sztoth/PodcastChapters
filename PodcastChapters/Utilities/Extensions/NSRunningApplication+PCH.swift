//
//  NSRunningApplication.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension NSRunningApplication {

    class func pch_ensureThereIsOnlyOneRunnningInstance(identifier: String = NSBundle.pch_bundleIdentifier()) {
        let applications = self.runningApplicationsWithBundleIdentifier(identifier)
        if 1 < applications.count {
            let alert = MultipleInstanceAlert()
            alert.runModal()

            if let instance = applications.filter({ $0 != self.currentApplication() }).first {
                instance.activateWithOptions([.ActivateAllWindows, .ActivateIgnoringOtherApps])
            }

            NSApp.terminate(nil)
        }
    }
}
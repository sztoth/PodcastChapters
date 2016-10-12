//
//  AppDelegate.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject {
    fileprivate var coordinator: AppCoordinator?
    fileprivate var appNotificationCenter: AppNotificationCenter?
}

extension AppDelegate: NSApplicationDelegate {

    // The following is a workaround for a nasty bug. The big rename broke the optional protocols.
    // For now the optional protocols have to be marked with an objective-c attribute.
    // Also the Notification has to be an NSNotification.
    @objc(applicationDidFinishLaunching:)
    func applicationDidFinishLaunching(_ notification: NSNotification) {
        NSRunningApplication.pch_ensureThereIsOnlyOneRunnningInstance()

        let components: [Bootstrapping] = [
            CrashReportBootstrapping(),
            ApplicationBootstrapping()
        ]

        setup(components)
    }

    @objc(applicationWillTerminate:)
    func applicationWillTerminate(_ notification: NSNotification) {
        appNotificationCenter?.clearAllNotifications()
    }
}

fileprivate extension AppDelegate {
    func setup(_ components: [Bootstrapping]) {
        do {
            let bootstrapped = try Bootstrapper.bootstrap(components)
            let application = try bootstrapped.component(ApplicationBootstrapping.self)
            coordinator = application.coordinator
        }
        catch BootstrappingError.expectedComponentNotFound(let componentName) {
            fatalError("\(componentName) was not bootstrapped. Terminating.")
        }
        catch let error as NSError {
            fatalError("Application launch failed: \(error)")
        }

        guard let _ = coordinator else {
            fatalError("Coordinator could not be created. Terminating.")
        }
    }
}

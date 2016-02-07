//
//  AppDelegate.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    private var coordinator: AppCoordinator?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let components: [Bootstrapping] = [
            CrashReportBootstrapping(),
            ApplicationBootstrapping()
        ]

        setup(components)
    }
}

private extension AppDelegate {

    func setup(components: [Bootstrapping]) {
        do {
            let bootstrapped = try Bootstrapper.bootstrap(components)
            let application = try bootstrapped.component(ApplicationBootstrapping.self)
            coordinator = application.coordinator
        }
        catch BootstrappingError.ExpectedComponentNotFound(let componentName) {
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

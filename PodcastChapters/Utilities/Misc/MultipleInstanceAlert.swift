//
//  MultipleInstanceAlert.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

class MultipleInstanceAlert: NSAlert {

    init(appName: String = Bundle.pch_appName()) {
        super.init()

        messageText = "Another instance of \(appName) is already running."
        informativeText = "Clicking the button will quit the current instance, but it will keep the other one."
        alertStyle = .critical
        addButton(withTitle: "\"Do it\" - Shyla Lebouf")
    }
}

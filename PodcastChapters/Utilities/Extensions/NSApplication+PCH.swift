//
//  NSApplication+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

protocol NSApplicationType {
    func terminate(_ sender: Any?)
}

extension NSApplication: NSApplicationType {}

//
//  NSApplication+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 21..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

protocol NSApplicationProtocol {
    func terminate(_ sender: AnyObject?)
}

//extension NSApplication: NSApplicationProtocol {}

//
//  NSTableView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 19..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

protocol Reusable: class {

    static var reuseIdentifier: String { get }
    static var nib: NSNib? { get }
}

extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    static var nib: NSNib? {
        return nil
    }
}

extension NSCollectionViewItem: Reusable {}

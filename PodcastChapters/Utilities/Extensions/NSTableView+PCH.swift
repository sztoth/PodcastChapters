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
        return String(Self)
    }

    static var nib: NSNib? {
        return nil
    }
}

extension NSTableView {

    func registerReusableView<T: NSView where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            registerNib(nib, forIdentifier: T.reuseIdentifier)
        }
    }

    func makeView<T: NSView where T: Reusable>(_: T.Type) -> T? {
        return makeViewWithIdentifier(T.reuseIdentifier, owner: nil) as? T
    }
}

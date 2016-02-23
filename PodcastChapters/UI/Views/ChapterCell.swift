//
//  ChapterCell.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 14..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

protocol WidthAdjustable {

    var preferredWidth: Double { get set }
}

class ChapterCell: NSView, Reusable, WidthAdjustable {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: NSTextField!

    static var nib: NSNib? {
        return NSNib(nibNamed: String(self), bundle: nil)
    }

    var preferredWidth: Double {
        get {
            return Double(widthConstraint.constant)
        }
        set(width) {
            titleLabel.preferredMaxLayoutWidth = CGFloat(width)
            widthConstraint.constant = CGFloat(width)
        }
    }

    var title: String {
        get {
            return titleLabel.stringValue
        }
        set(value) {
            titleLabel.stringValue = value
        }
    }

    var selected = false {
        didSet {
            let color = selected ? NSColor.grayColor() : NSColor.whiteColor()
            layer?.backgroundColor = color.CGColor
        }
    }
}

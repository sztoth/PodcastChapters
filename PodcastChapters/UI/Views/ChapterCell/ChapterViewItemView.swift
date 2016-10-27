//
//  ChapterViewItemView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChapterViewItemView: NSView {
    var text: String {
        get { return titleLabel.stringValue }
        set { titleLabel.stringValue = newValue }
    }
    var highlighted: Bool = false {
        didSet {
            highlighted ? select() : deselect()
        }
    }

    @IBOutlet fileprivate weak var titleLabel: NSTextField!

    fileprivate var backgroundColor = ColorSettings.subBackgroundColor {
        didSet {
            wantsLayer = true
            layer?.backgroundColor = backgroundColor.cgColor
        }
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        titleLabel.preferredMaxLayoutWidth = bounds.width
        super.resizeSubviews(withOldSize: oldSize)
    }
}

// MARK: - Setup

extension ChapterViewItemView {
    // After loading the ChapterViewItemView from the nib the titleLabel is nil but later it will have a value.
    // Do not know the reason yet, this is a workaround.
    func setup() {
        titleLabel.textColor = ColorSettings.textColor
    }
}

// MARK: - Highlight state

fileprivate extension ChapterViewItemView {
    func select() {
        backgroundColor = ColorSettings.cellSelectionColor
    }

    func deselect() {
        backgroundColor = ColorSettings.subBackgroundColor
    }
}

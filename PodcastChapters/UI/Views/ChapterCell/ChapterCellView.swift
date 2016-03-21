//
//  ChapterCellView.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 28..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

@IBDesignable class ChapterCellView: NSView {

    @IBOutlet weak var titleLabel: NSTextField!

    var backgroundColor = ColorSettings.subBackgroundColor {
        didSet {
            needsDisplay = true
        }
    }

    var text: String {
        get {
            return titleLabel.stringValue
        }
        set(value) {
            titleLabel.stringValue = value
        }
    }

    // The force unwrap is allowed because a fatalError will happen if the contentView
    // cannot be created. It is on purpose here.
    private var contentView: NSView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setupContentView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupContentView()
    }

    override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        super.resizeSubviewsWithOldSize(oldSize)
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        super.resizeSubviewsWithOldSize(oldSize)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        backgroundColor.setFill()
        NSRectFill(dirtyRect)
    }
}

extension ChapterCellView {

    func reset() {
        backgroundColor = ColorSettings.subBackgroundColor
    }

    func highlight() {
        backgroundColor = ColorSettings.cellSelectionColor
    }
}

private extension ChapterCellView {

    func setupContentView() {
        if let view: NSView = ChapterCellView.pch_loadFromNib(owner: self) {
            contentView = view
            contentView.frame = bounds
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)

            contentView.topAnchor.pch_equalToAnchor(self.topAnchor)
            contentView.bottomAnchor.pch_equalToAnchor(self.bottomAnchor)
            contentView.leadingAnchor.pch_equalToAnchor(self.leadingAnchor)
            contentView.trailingAnchor.pch_equalToAnchor(self.trailingAnchor)

            titleLabel.textColor = ColorSettings.textColor
        }
        else {
            fatalError("The contentView could not be created")
        }
    }
}

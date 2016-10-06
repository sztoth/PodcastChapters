//
//  ChapterCell.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChapterCell: NSCollectionViewItem {

    var text: String {
        get {
            return contentView?.text ?? ""
        }
        set(value) {
            contentView?.text = value
        }
    }

    var makeHighlighted: Bool = false {
        didSet {
            makeHighlighted ? contentView?.highlight() : contentView?.reset()
        }
    }

    fileprivate var contentView: ChapterCellView? {
        return view as? ChapterCellView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        makeHighlighted = false
    }
}

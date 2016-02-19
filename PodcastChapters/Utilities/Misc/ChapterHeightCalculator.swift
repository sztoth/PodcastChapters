//
//  ChapterCellHeightCalculator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 18..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

typealias ChapterCellConfiguration = (ChapterCell) -> ()

class ChapterHeightCalculator {

    var width: Double {
        get {
            return prototypeCell.preferredWidth
        }
        set(value) {
            prototypeCell.preferredWidth = value
        }
    }

    private let cache: NSCache
    private let prototypeCell: ChapterCell

    init(cache: NSCache = NSCache(), prototypeCell: ChapterCell? = ChapterCell.loadFromNib()) {
        self.cache = cache

        if let prototypeCell = prototypeCell {
            self.prototypeCell = prototypeCell
        }
        else {
            fatalError("The ChapterCell could not be loaded from the Nib file.")
        }
    }
}

extension ChapterHeightCalculator {

    func calculateHeight(configuration: ChapterCellConfiguration) -> CGFloat {
        configuration(prototypeCell)
        prototypeCell.layoutSubtreeIfNeeded()

        return prototypeCell.frame.height
    }
}

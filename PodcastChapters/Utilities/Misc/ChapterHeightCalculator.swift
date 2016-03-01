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

    private let cache: NSCache
    private let prototypeCellView: ChapterCellView
    private let widthConstraint: NSLayoutConstraint

    init(cache: NSCache = NSCache()) {
        self.cache = cache
        prototypeCellView = ChapterCellView(frame: NSRect.zero)

        widthConstraint = prototypeCellView.widthAnchor.constraintEqualToConstant(0.0)
        widthConstraint.active = true
    }
}

extension ChapterHeightCalculator {

    func calculateSizeFittingWidth(width: CGFloat, title: String) -> NSSize {
        prototypeCellView.text = title

        widthConstraint.constant = width
        prototypeCellView.layoutSubtreeIfNeeded()

        return prototypeCellView.bounds.size
    }
}

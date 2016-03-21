//
//  ChapterCellHeightCalculator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 18..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

typealias ChapterCellConfiguration = (ChapterCell) -> ()

class ChapterSizeCalculator {

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

extension ChapterSizeCalculator {

    func sizeForIndex(index: Int, availableWidth width: CGFloat, chapterTitle title: String) -> NSSize {
        let key = "\(index)"
        if let sizeValue = cache.objectForKey(key) as? NSValue {
            return sizeValue.sizeValue
        }

        prototypeCellView.text = title

        widthConstraint.constant = width
        prototypeCellView.layoutSubtreeIfNeeded()

        let size = prototypeCellView.bounds.size
        cache.setObject(NSValue(size: size), forKey: key)

        return size
    }

    func reset() {
        cache.removeAllObjects()
    }

    func resetItemAtIndex(index: Int) {
        let key = "\(index)"
        cache.removeObjectForKey(key)
    }
}

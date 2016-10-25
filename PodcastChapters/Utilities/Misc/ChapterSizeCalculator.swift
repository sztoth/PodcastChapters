//
//  ChapterCellHeightCalculator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 18..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChapterSizeCalculator {
    fileprivate let cache: NSCache<AnyObject, AnyObject>
    fileprivate let prototypeCellView: ChapterViewItemView
    fileprivate let widthConstraint: NSLayoutConstraint

    init(cache: NSCache<AnyObject, AnyObject> = NSCache()) {
        self.cache = cache
        prototypeCellView = ChapterViewItemView.pch_loadFromNib()!

        widthConstraint = prototypeCellView.widthAnchor.constraint(equalToConstant: 0.0)
        widthConstraint.priority = NSLayoutPriorityRequired
        widthConstraint.isActive = true
    }
}

extension ChapterSizeCalculator {

    func sizeForIndex(_ index: Int, availableWidth width: CGFloat, chapterTitle title: String) -> NSSize {
        let key = "\(index)"
        if let sizeValue = cache.object(forKey: key as AnyObject) as? NSValue {
            return sizeValue.sizeValue
        }

        prototypeCellView.text = title

        widthConstraint.constant = width
        prototypeCellView.layoutSubtreeIfNeeded()

        let size = prototypeCellView.bounds.size
        cache.setObject(NSValue(size: size), forKey: key as AnyObject)

        return size
    }

    func reset() {
        cache.removeAllObjects()
    }

    func resetItemAtIndex(_ index: Int) {
        let key = "\(index)"
        cache.removeObject(forKey: key as AnyObject)
    }
}

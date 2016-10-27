//
//  ChapterCellHeightCalculator.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 18..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChapterSizeCalculator {
    var width: CGFloat = 0.0 {
        didSet {
            widthConstraint.constant = width
            reset()
        }
    }

    fileprivate let cache: NSCache<NSString, NSValue>
    fileprivate let prototypeCellView: ChapterViewItemView
    fileprivate let widthConstraint: NSLayoutConstraint

    init(cache: NSCache<NSString, NSValue> = NSCache()) {
        self.cache = cache
        
        prototypeCellView = ChapterViewItemView.pch_loadFromNib()!

        widthConstraint = prototypeCellView.widthAnchor.constraint(equalToConstant: 0.0)
        widthConstraint.priority = NSLayoutPriorityRequired
        widthConstraint.isActive = true
    }
}

// MARK: - Size calculation

extension ChapterSizeCalculator {
    func size(for title: String, at index: Int) -> NSSize {
        let key = index.key
        if let cachedValue = cache.object(forKey: key) {
            return cachedValue.sizeValue
        }

        prototypeCellView.text = title
        prototypeCellView.layoutSubtreeIfNeeded()

        let size = prototypeCellView.bounds.size
        cache.setObject(NSValue(size: size), forKey: key)

        return size
    }
}

// MARK: - Reset

extension ChapterSizeCalculator {
    func reset() {
        cache.removeAllObjects()
    }

    func resetItemAtIndex(_ index: Int) {
        cache.removeObject(forKey: index.key)
    }
}

// MARK: - Other

fileprivate extension Int {
    var key: NSString {
        return "\(self)" as NSString
    }
}

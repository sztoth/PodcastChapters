//
//  NSCollectionView+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

extension NSCollectionView {
    func scrollToItems(at indexPaths: Set<IndexPath>, scrollPosition: NSCollectionViewScrollPosition, animated: Bool) {
        if animated {
            let ctx = NSAnimationContext.current()
            ctx.allowsImplicitAnimation = true
        }

        scrollToItems(at: indexPaths, scrollPosition: scrollPosition)
    }
}

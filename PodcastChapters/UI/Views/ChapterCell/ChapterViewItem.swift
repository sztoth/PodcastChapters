//
//  ChapterViewItem.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChapterViewItem: NSCollectionViewItem {
    var text: String {
        get { return chapterView.text }
        set { chapterView.text = newValue }
    }
    var highlighted: Bool {
        get { return chapterView.highlighted }
        set { chapterView.highlighted = newValue }
    }

    fileprivate var chapterView: ChapterViewItemView {
        return view as! ChapterViewItemView
    }

    override func loadView() {
        let customView: ChapterViewItemView = ChapterViewItemView.pch_loadFromNib()!
        view = customView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        highlighted = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chapterView.setup()
        highlighted = false
    }
}

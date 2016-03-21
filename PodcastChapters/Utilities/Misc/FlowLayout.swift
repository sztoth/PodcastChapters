//
//  FlowLayout.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 25..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class FlowLayout: NSCollectionViewFlowLayout {

    override init() {
        super.init()

        setupBasicParameters()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupBasicParameters()
    }
}

private extension FlowLayout {

    func setupBasicParameters() {
//        itemSize = NSSize(width: 100, height: 100)
//        minimumLineSpacing = 10.0
//        minimumInteritemSpacing = 10.0
//        sectionInset = NSEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
}

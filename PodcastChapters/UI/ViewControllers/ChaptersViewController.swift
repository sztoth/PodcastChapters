//
//  ChaptersViewController.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class ChaptersViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    private let viewModel: ChaptersViewModel
    private let heightCalculator: ChapterHeightCalculator
    private let disposeBag = DisposeBag()

    init?(viewModel: ChaptersViewModel, heightCalculator: ChapterHeightCalculator = ChapterHeightCalculator()) {
        self.viewModel = viewModel
        self.heightCalculator = heightCalculator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()

        viewModel.chapterChanged
            .subscribeNext { _ in
                self.collectionView.reloadData()
            }
            .addDisposableTo(disposeBag)
    }
}

extension ChaptersViewController: NSCollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfChapters()
    }

    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        return collectionView.makeItemWithIdentifier(ChapterCell.reuseIdentifier, forIndexPath: indexPath)
    }
}

extension ChaptersViewController: NSCollectionViewDelegate {

    func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        if let chapterData = viewModel.chapterDataForIndex(indexPath.item) {
            return heightCalculator.calculateSizeFittingWidth(collectionView.frame.width, title: chapterData.0)
        }

        return NSSize.zero
    }

    func collectionView(collectionView: NSCollectionView, willDisplayItem item: NSCollectionViewItem, forRepresentedObjectAtIndexPath indexPath: NSIndexPath) {
        if let item = item as? ChapterCell, chapterData = viewModel.chapterDataForIndex(indexPath.item) {
            item.text = chapterData.0
        }
    }
}

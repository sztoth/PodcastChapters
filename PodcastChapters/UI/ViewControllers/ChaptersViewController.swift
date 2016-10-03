//
//  ChaptersViewController.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class ChaptersViewController: NSViewController {

    @IBOutlet fileprivate weak var coverImageView: NSImageView!
    @IBOutlet fileprivate weak var titleLabel: NSTextField!
    @IBOutlet fileprivate weak var copyButton: CopyButton!
    @IBOutlet fileprivate weak var collectionView: CollectionView!

    fileprivate let viewModel: ChaptersViewModel
    fileprivate let sizeCalculator: ChapterSizeCalculator
    fileprivate let disposeBag = DisposeBag()

    init?(viewModel: ChaptersViewModel, sizeCalculator: ChapterSizeCalculator = ChapterSizeCalculator()) {
        self.viewModel = viewModel
        self.sizeCalculator = sizeCalculator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = ColorSettings.textColor

        setupBindings()
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        view.layoutSubtreeIfNeeded()
    }
}

// MARK: - Copy to clipboard function
extension ChaptersViewController {
    @IBAction func copyCurrentTitleToClipboard(_ sender: CopyButton) {
        viewModel.copyCurrentChapterTitleToClipboard()
    }
}

// MARK: - CollectionView data source
extension ChaptersViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfChapters()
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return collectionView.makeItem(withIdentifier: ChapterCell.reuseIdentifier, for: indexPath)
    }
}

// MARK: - ColectionView delegate
extension ChaptersViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> NSSize {
        if let title = viewModel.chapterDataFor(index: (indexPath as NSIndexPath).item) {
            return sizeCalculator.sizeForIndex((indexPath as NSIndexPath).item, availableWidth: collectionView.frame.width, chapterTitle: title)
        }

        return NSSize.zero
    }

    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        if let item = item as? ChapterCell, let title = viewModel.chapterDataFor(index: (indexPath as NSIndexPath).item) {
            item.text = title
            item.makeHighlighted = false
        }
    }
}

// MARK: - Private
fileprivate extension ChaptersViewController {
    func setupBindings() {
        viewModel.artwork
            .drive(coverImageView.rx.image)
            .addDisposableTo(disposeBag)

        /*viewModel.title
         .drive(titleLabel.rx.text)
         .addDisposableTo(disposeBag)*/

        viewModel.chapterChanged
            .drive(onNext: reload(indexes:))
            .addDisposableTo(disposeBag)
    }

    func reload(indexes: (Int?, Int?)) {
        var array = [IndexPath]()
        var scrollToPath: IndexPath?

        switch indexes {
        case let (.some(old), .some(new)):
            array.append(IndexPath(item: old, section: 0))

            let indexPath = IndexPath(item: new, section: 0)
            scrollToPath = indexPath
            array.append(indexPath)
        case let (.some(old), .none):
            array.append(IndexPath(item: old, section: 0))
        case let (.none, .some(new)):
            let indexPath = IndexPath(item: new, section: 0)
            scrollToPath = indexPath
            array.append(indexPath)
        default:
            break
        }

        if 0 < array.count {
            self.collectionView.reloadItems(at: Set(array))
        }
        else {
            self.updateCollectionView()
        }

        if let indexPath = scrollToPath {
            self.collectionView.scrollToItems(at: Set([indexPath]), scrollPosition: .centeredVertically)
        }
    }

    func updateCollectionView() {
        self.sizeCalculator.reset()
        self.collectionView.reloadData()
    }
}

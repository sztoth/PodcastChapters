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
    @IBOutlet fileprivate weak var collectionView: NSCollectionView!

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

        setupBindings()
        setupColors()
    }

    override func viewDidLayout() {
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width

        super.viewDidLayout()

        sizeCalculator.width = collectionView.bounds.width
    }
}

// MARK: - Copy to clipboard

extension ChaptersViewController {
    @IBAction func copyCurrentTitleToClipboard(_ sender: CopyButton) {
        viewModel.copyCurrentChapterTitleToClipboard()
    }
}

// MARK: - NSCollectionViewDataSource

extension ChaptersViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfChapters()
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "ChapterViewItem", for: indexPath)
        guard let collectionViewItem = item as? ChapterViewItem else { return item }

        if let data = viewModel.chapterData(for: indexPath.item) {
            collectionViewItem.text = data.0
            collectionViewItem.highlighted = data.1
        }

        return collectionViewItem
    }
}

// MARK: - NSCollectionViewDelegate

extension ChaptersViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> NSSize {
        if let data = viewModel.chapterData(for: indexPath.item) {
            return sizeCalculator.size(for: data.0, at: indexPath.item)
        }

        return NSSize.zero
    }
}

// MARK: - Setup

fileprivate extension ChaptersViewController {
    func setupBindings() {
        viewModel.artwork
            .drive(coverImageView.rx.image)
            .addDisposableTo(disposeBag)

        viewModel.title
            .drive(titleLabel.rx.textInput.text)
            .addDisposableTo(disposeBag)

        viewModel.chapterChanged
            .drive(onNext: reload(indexes:))
            .addDisposableTo(disposeBag)
    }

    func setupColors() {
        titleLabel.textColor = ColorSettings.textColor

        collectionView.wantsLayer = true
        collectionView.layer?.backgroundColor = ColorSettings.mainBackgroundColor.cgColor
    }
}

// MARK: - Reload

fileprivate extension ChaptersViewController {
    func reload(indexes: (Int?, Int?)) {
        var array = [IndexPath]()
        var scrollToPath: IndexPath?

        switch indexes {
        case let (.some(old), .some(new)):
            array.append(IndexPath(item: old, section: 0))

            let indexPath = IndexPath(item: new, section: 0)
            scrollToPath = indexPath
            array.append(indexPath)
        case let (.none, .some(new)):
            let indexPath = IndexPath(item: new, section: 0)
            scrollToPath = indexPath
            array.append(indexPath)
        default:
            // Empty on purpose
            break
        }

        if !array.isEmpty {
            collectionView.reloadItems(at: Set(array))

            if let indexPath = scrollToPath {
                collectionView.scrollToItems(at: Set([indexPath]), scrollPosition: .centeredVertically, animated: true)
            }
        }
        else {
            sizeCalculator.reset()
            collectionView.reloadData()
        }
    }
}

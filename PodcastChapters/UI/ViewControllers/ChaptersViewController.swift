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

    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var playbackIndicator: PlaybackIndicatorView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var copyButton: CopyButton!
    @IBOutlet weak var collectionView: CollectionView!

    private let viewModel: ChaptersViewModel
    private let sizeCalculator: ChapterSizeCalculator
    private let disposeBag = DisposeBag()

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

        viewModel.artwork.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(coverImageView.rx_image)
            .addDisposableTo(disposeBag)

        viewModel.title.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(titleLabel.rx_text)
            .addDisposableTo(disposeBag)

        viewModel.isPlaying
            .observeOn(MainScheduler.instance)
            .subscribeNext { isPlaying in
                self.playbackIndicator.state = isPlaying ? .Playing : .Stopped
            }
            .addDisposableTo(disposeBag)

        viewModel.podcastChanged
            .observeOn(MainScheduler.instance)
            .subscribeNext { _ in
                self.updateCollectionView()
            }
            .addDisposableTo(disposeBag)

        viewModel.chapterChanged
            .observeOn(MainScheduler.instance)
            .subscribeNext { indexes in
                var array = [NSIndexPath]()
                var scrollToPath: NSIndexPath?

                switch indexes {
                case let (.Some(old), .Some(new)):
                    array.append(NSIndexPath(forItem: old, inSection: 0))

                    let indexPath = NSIndexPath(forItem: new, inSection: 0)
                    scrollToPath = indexPath
                    array.append(indexPath)
                case let (.Some(old), .None):
                    array.append(NSIndexPath(forItem: old, inSection: 0))
                case let (.None, .Some(new)):
                    let indexPath = NSIndexPath(forItem: new, inSection: 0)
                    scrollToPath = indexPath
                    array.append(indexPath)
                default:
                    break
                }

                if 0 < array.count {
                    self.collectionView.reloadItemsAtIndexPaths(Set(array))
                }
                else {
                    self.updateCollectionView()
                }

                if let indexPath = scrollToPath {
                    self.collectionView.scrollToItemsAtIndexPaths(Set([indexPath]), scrollPosition: .CenteredVertically)
                }
            }
            .addDisposableTo(disposeBag)
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        view.layoutSubtreeIfNeeded()
    }
}

extension ChaptersViewController {

    @IBAction func copyCurrentTitleToClipboard(sender: CopyButton) {
        viewModel.copyCurrentChapterTitleToClipboard()
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
            return sizeCalculator.sizeForIndex(indexPath.item, availableWidth: collectionView.frame.width, chapterTitle: chapterData.0)
        }

        return NSSize.zero
    }

    func collectionView(collectionView: NSCollectionView, willDisplayItem item: NSCollectionViewItem, forRepresentedObjectAtIndexPath indexPath: NSIndexPath) {
        if let item = item as? ChapterCell, chapterData = viewModel.chapterDataForIndex(indexPath.item) {
            item.text = chapterData.title
            item.makeHighlighted = chapterData.playing
        }
    }
}

private extension ChaptersViewController {

    func updateCollectionView() {
        self.sizeCalculator.reset()
        self.collectionView.reloadData()
    }
}

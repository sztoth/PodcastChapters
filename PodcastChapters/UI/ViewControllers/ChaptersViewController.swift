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

    @IBOutlet weak var tableView: NSTableView!

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

        tableView.registerReusableView(ChapterCell)

        self.viewModel.chapterChanged
            .subscribeNext { _ in
                self.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
    }
}

private extension ChaptersViewController {

    func configureCell(cell: ChapterCell, inColumn column: NSTableColumn?, atRow row: Int) {
        guard let column = column, chapterData = viewModel.chapterDataForIndex(row) else {
            return
        }

        cell.preferredWidth = Double(column.width)
        cell.title = chapterData.0
    }
}

extension ChaptersViewController: NSTableViewDataSource {

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return viewModel.numberOfChapters()
    }
}

extension ChaptersViewController: NSTableViewDelegate {

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let height = heightCalculator.calculateHeight { cell in
            self.configureCell(cell, inColumn: tableView.tableColumns.first, atRow: row)
        }

        return height
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(ChapterCell) else {
            return nil
        }

        configureCell(cell, inColumn: tableColumn, atRow: row)

        return cell
    }

    func tableView(tableView: NSTableView, willDisplayCell cell: AnyObject, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        // This is not called with view based NSTableview
    }
}

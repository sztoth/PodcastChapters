//
//  ChaptersViewController.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa

class ChaptersViewController: NSViewController {

    private let viewModel: ChaptersViewModel

    @IBOutlet weak var testLabel: NSTextField!

    init?(viewModel: ChaptersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.stringValue = viewModel.title
    }
}

private extension ChaptersViewController {

    @IBAction func quit(sender: AnyObject) {

    }
}

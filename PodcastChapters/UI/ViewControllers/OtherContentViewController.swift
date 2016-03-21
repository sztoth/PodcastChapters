//
//  OtherContentViewController.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 23..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift

class OtherContentViewController: NSViewController {

    @IBOutlet weak var messageLabel: NSTextField!

    private let viewModel: OtherContentViewModel
    private let disposeBag = DisposeBag()

    init?(viewModel: OtherContentViewModel = OtherContentViewModel()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.textColor = ColorSettings.textColor

        viewModel.title.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(messageLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
}

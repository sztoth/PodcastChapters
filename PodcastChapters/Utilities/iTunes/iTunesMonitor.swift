//
//  iTunesMonitor.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

class iTunesMonitor {

    private let iTunes: iTunesApp
    private let disposeBag = DisposeBag()

    init(iTunes: iTunesApp = iTunesApp()) {
        self.iTunes = iTunes

        self.iTunes.playerState
            .subscribeNext { state in
                print("State: \(state)")
            }
            .addDisposableTo(disposeBag)

        self.iTunes.playerPosition
            .subscribeNext { position in
                print("Position: \(position)")
            }
            .addDisposableTo(disposeBag)

        self.iTunes.nowPlaying
            .subscribeNext { item in
                print("Item: \(item)")

                if case .Podcast(let mediaItem) = item {
                    iTunesLibrary.fetchURLForPesistentID(mediaItem.persistentID)
                        .subscribe { event in
                            switch event {
                            case .Next(let URL):
                                print("URL: \(URL)")
                            case .Error(let error):
                                print("Error: \(error)")
                            default:
                                print("Default")
                            }
                        }
                        .addDisposableTo(self.disposeBag)
                }
            }
            .addDisposableTo(disposeBag)
    }
}
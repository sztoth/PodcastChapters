//
//  MediaLoaderMock.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Cocoa
import RxSwift
@testable
import PodcastChapters

class MediaLoaderMock {
    var sendError: MediaLoader.LibraryError?
    var sendURL: URL?
}

extension MediaLoaderMock: MediaLoaderType {
    func URLFor(identifier: String) -> Observable<URL> {
        if let error = sendError {
            return Observable.error(error)
        }
        else if let URL = sendURL {
            return Observable.just(URL)
        }

        fatalError("You forgot to specify an error or a URL")
    }
}

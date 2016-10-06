//
//  MediaLoader.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

class MediaLoader {
    fileprivate let library: MediaLibraryType

    init(library: MediaLibraryType) {
        self.library = library
    }
}

extension MediaLoader {
    func URLFor(identifier: String) -> Observable<URL> {
        return Observable.create { observer in
            if let identifierNumber = NSNumber.pch_numberFromHex(identifier) {
                if self.library.reloadData() {
                    let item = self.library.allMediaItems.filter({ $0.persistentID == identifierNumber }).first
                    if let location = item?.location {
                        observer.onNext(location)
                        observer.onCompleted()
                    }
                    else {
                        observer.on(.error(LibraryError.itemNotFound))
                    }
                }
                else {
                    observer.on(.error(LibraryError.libraryNotReloaded))
                }
            }
            else {
                observer.on(.error(LibraryError.persistentIDInvalid))
            }

            return Disposables.create()
        }
    }
}

extension MediaLoader {
    enum LibraryError: Error {
        case libraryNotReloaded
        case itemNotFound
        case persistentIDInvalid
    }
}

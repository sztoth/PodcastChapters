//
//  iTunesLibrary.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import iTunesLibrary
import Foundation
import RxSwift

enum iTunesLibraryError: Error {
    case libraryNotAccessible(NSError)
    case itemNotFound
    case persistentIDTooLarge
}

class iTunesLibrary {

    static func fetchURLForPesistentID(_ identifier: String) -> Observable<URL> {
        return Observable.create { observer in
            if let persistentNumber = NSNumber.pch_numberFromHex(identifier) {
                do {
                    let library = try ITLibrary(apiVersion: "1.0")
                    let items = library.allMediaItems as NSArray

                    let predicate = NSPredicate(format: "persistentID == %@", persistentNumber)
                    let filtered = items.filtered(using: predicate)

                    if let item = filtered.first as? ITLibMediaItem, let location = item.location {
                        observer.onNext(location)
                        observer.onCompleted()
                    }
                    else {
                        observer.on(.error(iTunesLibraryError.itemNotFound))
                    }
                }
                catch let error as NSError {
                    observer.on(.error(iTunesLibraryError.libraryNotAccessible(error)))
                }
            }
            else {
                observer.on(.error(iTunesLibraryError.persistentIDTooLarge))
            }

            return Disposables.create()
        }
    }
}

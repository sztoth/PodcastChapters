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

enum iTunesLibraryError: ErrorType {
    case LibraryNotAccessible(NSError)
    case ItemNotFound
    case PersistentIDTooLarge
}

class iTunesLibrary {

    static func fetchURLForPesistentID(identifier: String) -> Observable<NSURL> {
        return Observable.create { observer in
            if let persistentNumber = NSNumber.pch_numberFromHex(identifier) {
                do {
                    let library = try ITLibrary(APIVersion: "1.0")
                    let items = library.allMediaItems as NSArray

                    let predicate = NSPredicate(format: "persistentID == %@", persistentNumber)
                    let filtered = items.filteredArrayUsingPredicate(predicate)

                    if let item = filtered.first as? ITLibMediaItem {
                        observer.onNext(item.location)
                        observer.onCompleted()
                    }
                    else {
                        observer.on(.Error(iTunesLibraryError.ItemNotFound))
                    }
                }
                catch let error as NSError {
                    observer.on(.Error(iTunesLibraryError.LibraryNotAccessible(error)))
                }
            }
            else {
                observer.on(.Error(iTunesLibraryError.PersistentIDTooLarge))
            }

            return NopDisposable.instance
        }
    }
}

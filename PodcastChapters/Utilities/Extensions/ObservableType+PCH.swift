//
//  ObservableType+PCH.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 09. 26..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func mapToVoid() -> Observable<Void> {
        return map { _ -> Void in
            return ()
        }
    }
}

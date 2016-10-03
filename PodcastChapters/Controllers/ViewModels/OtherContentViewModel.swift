//
//  OtherContentViewModel.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 23..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class OtherContentViewModel {

    var title: Driver<String> {
        return _title.asDriver()
    }

    fileprivate let _title = Variable<String>("Sorry, but the current item in iTunes is not a podcast.")
}

//
//  ChapterLoader.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AVFoundation
import RxSwift

class ChapterLoader {
    static func chaptersFrom(asset: AVAsset) -> Observable<[MNAVChapter]?> {
        return Observable.create { observer in
            let reader = MNAVChapterReader()
            let chapters = reader.chapters(from: asset) as? [MNAVChapter]

            observer.onNext(chapters)
            observer.onCompleted()

            return Disposables.create()
        }
    }
}

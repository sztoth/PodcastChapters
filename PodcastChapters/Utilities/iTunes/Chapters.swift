//
//  Chapters.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AVFoundation
import RxSwift

class Chapters {

    class func chaptersFromAsset(asset: AVAsset) -> Observable<Chapters> {
        return Observable.create { observer in
            let reader = MNAVChapterReader()
            let chapterArray = reader.chaptersFromAsset(asset)
            let chapters = Chapters(chapters: chapterArray)

            observer.onNext(chapters)
            observer.onCompleted()

            return NopDisposable.instance
        }
    }

    let list: [MNAVChapter]

    private init(chapters: NSArray) {
        list = chapters as! [MNAVChapter]
    }

    func chapterIndexForPosition(position: CDouble) -> Int? {
        for (index, chapter) in list.enumerate() {
            let startPosition = CMTimeGetSeconds(chapter.time)
            let duration = CMTimeGetSeconds(chapter.duration)

            if startPosition <= position && position < startPosition + duration {
                return index
            }
        }

        return nil
    }
}
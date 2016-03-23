//
//  Podcast.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

struct Chapter {

    let cover: NSImage?
    let title: String
    let start: CMTime?
    let duration: CMTime?
}

extension Chapter {

    func containsPosition(position: CDouble) -> Bool {
        guard let start = start, duration = duration else {
            return true
        }

        let startPostion = CMTimeGetSeconds(start)
        let chapterDuration = CMTimeGetSeconds(duration)

        if startPostion <= position && position < startPostion + chapterDuration {
            return true
        }

        return false
    }
}

//
//  Podcast.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 22..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation

struct Chapter {

    let cover: NSImage?
    let title: String
    let start: CMTime?
    let duration: CMTime?
}

extension Chapter {

    func containsPosition(_ position: CDouble) -> Bool {
        guard let start = start, let duration = duration else {
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

//
//  PasteboardContentStripper.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 20..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

private typealias Rule = (String) -> (String)

class PasteBoardContentStripper {

    fileprivate let rules: [Rule]

    init() {
        rules = [
            { content in
                content.replacingOccurrences(of: "\"", with: "")
            },
            { content in
                var processedContent = content
                if let regex = try? NSRegularExpression(pattern: "\\[.*\\]", options: .caseInsensitive) {
                    let range = NSRange(location: 0, length: processedContent.characters.count)
                    processedContent = regex.stringByReplacingMatches(in: processedContent, options: .withTransparentBounds, range: range, withTemplate: "")
                }

                return processedContent
            }
        ] as [Rule]
    }
}

extension PasteBoardContentStripper {

    func strip(_ content: String) -> String {
        var strippedContent = content
        rules.forEach { rule in
            strippedContent = rule(strippedContent)
        }

        return strippedContent
    }
}

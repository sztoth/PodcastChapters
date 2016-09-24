//
//  iTunesApp.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import Foundation
import RxSwift
import ScriptingBridge

enum iTunesPlayerState: String {
    case Playing = "Playing"
    case Paused = "Paused"
    case Stopped = "Stopped"
    case Unknown = "Unknown"

    fileprivate static func fromState(_ state: iTunesEPlS?) -> iTunesPlayerState? {
        guard let state = state else {
            return nil
        }

        switch state {
        case iTunesEPlS.iTunesEPlSPlaying:
            return .Playing

        case iTunesEPlS.iTunesEPlSPaused:
            return .Paused

        case iTunesEPlS.iTunesEPlSStopped:
            return .Stopped

        default:
            return .Unknown
        }
    }
}

enum iTunesNowPlaying {
    case podcast(iTunesMediaItem)
    case other(iTunesMediaItem)
    case unknown
}

struct iTunesMediaItem {
    let persistentID: String
    let artist: String
    let name: String
    let artwork: NSImage?

    init(persistentID: NSString, artist: NSString, name: NSString, artwork: NSImage?) {
        self.persistentID = persistentID as String
        self.artist = artist as String
        self.name = name as String
        self.artwork = artwork
    }
}

class iTunesApp {

    static let BundleIdentifier = "com.apple.iTunes"

    var playerState: Observable<iTunesPlayerState> {
        return _playerState.asObservable()
    }

    var playerPosition: Observable<CDouble?> {
        return _playerPosition.asObservable()
    }

    var nowPlaying: Observable<iTunesNowPlaying> {
        return _nowPlaying.asObservable()
    }

    fileprivate let _playerState = Variable<iTunesPlayerState>(.Unknown)
    fileprivate let _playerPosition = Variable<CDouble?>(nil)
    fileprivate let _nowPlaying = Variable<iTunesNowPlaying>(.unknown)
    fileprivate let iTunes: iTunesApplication
    fileprivate let notificationCenter: DistributedNotificationCenter
    fileprivate var timer: Timer?

    init(
        iTunes: iTunesApplication = SBApplication.pch_iTunes(),
        notificationCenter: DistributedNotificationCenter = DistributedNotificationCenter.default())
    {
        self.iTunes = iTunes
        self.notificationCenter = notificationCenter

        let notificationName = iTunesApp.BundleIdentifier + ".playerInfo"
        self.notificationCenter.addObserver(forName: NSNotification.Name(rawValue: notificationName), object: nil, queue: nil) { [weak self] notification in
            self?.update()
        }

        update()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}

private extension iTunesApp {

    func update() {
        guard let state = iTunesPlayerState.fromState(iTunes.playerState) else {
            _playerState.value = .Unknown
            _playerPosition.value = nil
            _nowPlaying.value = .unknown
            return
        }

        if _playerState.value != state {
            _playerState.value = state

            switch state {
            case .Playing:
                startTimer()
            case .Paused:
                stopTimer()
            case .Stopped, .Unknown:
                cancelTimer()
            }
        }

        var nowPlaying = iTunesNowPlaying.unknown
        if let
            persistentID = iTunes.currentTrack?.persistentID,
            let artist = iTunes.currentTrack?.artist,
            let name = iTunes.currentTrack?.name,
            let podcast = iTunes.currentTrack?.podcast
        {
            var artwork: NSImage? = nil
            if let cover = iTunes.currentTrack?.artworks?().first {
                artwork = cover.data
            }

            let mediaItem = iTunesMediaItem(persistentID: persistentID, artist: artist, name: name, artwork: artwork)
            nowPlaying = podcast ? iTunesNowPlaying.podcast(mediaItem) : iTunesNowPlaying.other(mediaItem)
        }

        if _nowPlaying.value != nowPlaying {
            _nowPlaying.value = nowPlaying
        }
    }
}

private extension iTunesApp {

    func startTimer() {
        timer = Timer(interval: 1.0, repeats: true) { _ in
            self._playerPosition.value = self.iTunes.playerPosition
        }
    }

    func stopTimer() {
        timer = nil
    }

    func cancelTimer() {
        stopTimer()

        _playerPosition.value = nil
    }
}

extension iTunesNowPlaying: CustomStringConvertible {

    var description: String {
        switch self {
        case let .podcast(item):
            return "Podcast(\(item.persistentID), \(item.artist), \(item.name))"

        case let .other(item):
            return "Other(\(item.persistentID), \(item.artist), \(item.name))"

        default:
            return "Unknown"
        }
    }
}

extension iTunesNowPlaying: Equatable {}

func ==(lhs: iTunesNowPlaying, rhs: iTunesNowPlaying) -> Bool {
    switch (lhs, rhs) {
    case (let .podcast(itemA), let .podcast(itemB)):
        return itemA.persistentID == itemB.persistentID

    case (let .other(itemA), let .other(itemB)):
        return itemA.persistentID == itemB.persistentID

    default:
        return false
    }
}

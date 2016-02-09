//
//  iTunesApp.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift
import ScriptingBridge

enum iTunesPlayerState: String {
    case Playing = "Playing"
    case Paused = "Paused"
    case Stopped = "Stopped"
    case Unknown = "Unknown"

    private static func fromState(state: iTunesEPlS?) -> iTunesPlayerState? {
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
    case Podcast(iTunesMediaItem)
    case Other(iTunesMediaItem)
    case Unknown
}

struct iTunesMediaItem {
    private let persistentID: String
    private let artist: String
    private let name: String

    init(persistentID: NSString, artist: NSString, name: NSString) {
        self.persistentID = persistentID as String
        self.artist = artist as String
        self.name = name as String
    }
}

class iTunesApp {

    static let BundleIdentifier = "com.apple.iTunes"

    var playerState: Observable<iTunesPlayerState> {
        return _playerState.asObservable()
    }

    var playerPosition: Observable<CDouble> {
        return _playerPosition.asObservable()
    }

    var nowPlaying: Observable<iTunesNowPlaying> {
        return _nowPlaying.asObservable()
    }

    private let _playerState = Variable<iTunesPlayerState>(.Unknown)
    private let _playerPosition = Variable<CDouble>(0.0)
    private let _nowPlaying = Variable<iTunesNowPlaying>(.Unknown)
    private let iTunes: iTunesApplication
    private let notificationCenter: NSDistributedNotificationCenter
    private var timer: Timer?

    init(
        iTunes: iTunesApplication = SBApplication.pch_iTunes(),
        notificationCenter: NSDistributedNotificationCenter = NSDistributedNotificationCenter.defaultCenter())
    {
        self.iTunes = iTunes
        self.notificationCenter = notificationCenter

        let notificationName = iTunesApp.BundleIdentifier + "playerInfo"
        self.notificationCenter.addObserverForName(notificationName, object: nil, queue: nil) { [weak self] notification in
            self?.update()
        }

        update()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func testMethod() {
        print("It is alive")
    }
}

private extension iTunesApp {

    func update() {
        guard let state = iTunesPlayerState.fromState(iTunes.playerState) else {
            _playerState.value = .Unknown
            _playerPosition.value = 0.0
            _nowPlaying.value = .Unknown
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

        var nowPlaying = iTunesNowPlaying.Unknown
        if let
            persistentID = iTunes.currentTrack?.persistentID,
            artist = iTunes.currentTrack?.artist,
            name = iTunes.currentTrack?.name,
            podcast = iTunes.currentTrack?.podcast
        {
            let mediaItem = iTunesMediaItem(persistentID: persistentID, artist: artist, name: name)
            nowPlaying = podcast ? iTunesNowPlaying.Podcast(mediaItem) : iTunesNowPlaying.Other(mediaItem)
        }

        if _nowPlaying.value != nowPlaying {
            _nowPlaying.value = nowPlaying
        }
    }
}

private extension iTunesApp {

    func startTimer() {
        timer = Timer(interval: 1.0, repeats: true) { _ in
            self._playerPosition.value = self.iTunes.playerPosition ?? 0.0
        }
    }

    func stopTimer() {
        timer = nil
    }

    func cancelTimer() {
        stopTimer()

        _playerPosition.value = 0.0
    }
}

extension iTunesNowPlaying: CustomStringConvertible {

    var description: String {
        switch self {
        case let .Podcast(item):
            return "Podcast(\(item.persistentID), \(item.artist), \(item.name))"

        case let .Other(item):
            return "Other(\(item.persistentID), \(item.artist), \(item.name))"

        default:
            return "Unknown"
        }
    }
}

extension iTunesNowPlaying: Equatable {}

func ==(lhs: iTunesNowPlaying, rhs: iTunesNowPlaying) -> Bool {
    switch (lhs, rhs) {
    case (let .Podcast(itemA), let .Podcast(itemB)):
        return itemA.persistentID == itemB.persistentID

    case (let .Other(itemA), let .Other(itemB)):
        return itemA.persistentID == itemB.persistentID

    default:
        return false
    }
}

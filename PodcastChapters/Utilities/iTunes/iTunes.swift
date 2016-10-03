//
//  iTunes.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import AppKit
import RxSwift
import ScriptingBridge

class iTunes {
    var playerState: Observable<PlayerState> {
        return _playerState.asObservable().distinctUntilChanged()
    }
    var playerPosition: Observable<Double?> {
        return _playerPosition.asObservable()
    }
    var nowPlaying: Observable<iTunesTrackWrapper?> {
        return _nowPlaying.asObservable()
    }

    fileprivate let _playerState = Variable<PlayerState>(.unknown)
    fileprivate let _playerPosition = Variable<Double?>(nil)
    fileprivate let _nowPlaying = Variable<iTunesTrackWrapper?>(nil)
    fileprivate let itunesApplication: iTunesApplicationWrapper
    fileprivate let notificationCenter: DistributedNotificationCenter

    fileprivate var timer: Timer?

    init(
        itunesApplication: iTunesApplicationWrapper = SBApplication.pch_iTunes(),
        notificationCenter: DistributedNotificationCenter = DistributedNotificationCenter.default()
    ) {
        self.itunesApplication = itunesApplication
        self.notificationCenter = notificationCenter

        setupNotificationObserver()
        updatePlayer()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}

// MARK: - Private stuff
fileprivate extension iTunes {
    func setupNotificationObserver() {
        let notificationName = NSNotification.Name(rawValue: "\(iTunesBundleIdentifier).playerInfo")
        self.notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] _ in
            self?.updatePlayer()
        }
    }

    func updatePlayer() {
        guard itunesApplication.playerState != .unknown else {
            _playerState.value = .unknown
            _playerPosition.value = nil
            _nowPlaying.value = nil
            return
        }

        changeTimerIfNeededFor(state: itunesApplication.playerState)

        print("ID: \(itunesApplication.currentTrack?.identifier)")
        print("Artist: \(itunesApplication.currentTrack?.artist)")
        print("Name: \(itunesApplication.currentTrack?.title)")
        print("Podcast: \(itunesApplication.currentTrack?.isPodcast)")
        print("")

        _nowPlaying.value = itunesApplication.currentTrack
    }
}

// MARK: - Timer related stuffs
fileprivate extension iTunes {
    func changeTimerIfNeededFor(state: PlayerState) {
        _playerState.value = state

        switch state {
        case .playing:
            startTimer()
        case .paused:
            stopTimer()
        case .stopped, .unknown:
            cancelTimer()
        }
    }

    func startTimer() {
        guard timer == nil else { return }

        timer = Timer(interval: Constant.UpdateInterval, repeats: true) { _ in
            self._playerPosition.value = self.itunesApplication.playerPosition
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

// MARK: - Constants
fileprivate extension iTunes {
    enum Constant {
        static let UpdateInterval = 1.0
    }
}

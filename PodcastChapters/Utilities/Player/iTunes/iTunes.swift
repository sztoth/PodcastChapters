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

protocol iTunesType {
    var playerState: Observable<PlayerState> { get }
    var playerPosition: Observable<Double?> { get }
    var nowPlaying: Observable<iTunesTrackWrapperType?> { get }
}

class iTunes: iTunesType {
    var playerState: Observable<PlayerState> {
        return _playerState.asObservable().distinctUntilChanged()
    }
    var playerPosition: Observable<Double?> {
        return _playerPosition.asObservable()
    }
    var nowPlaying: Observable<iTunesTrackWrapperType?> {
        return _nowPlaying.asObservable().distinctUntilChanged { $0?.identifier == $1?.identifier }
    }

    fileprivate let _playerState = Variable<PlayerState>(.unknown)
    fileprivate let _playerPosition = Variable<Double?>(nil)
    fileprivate let _nowPlaying = Variable<iTunesTrackWrapperType?>(nil)
    fileprivate let itunesApplication: iTunesApplicationWrapperType
    fileprivate let notificationCenter: DistributedNotificationCenterType

    fileprivate var timer: Timer?
    fileprivate var observer: NSObjectProtocol?

    init(
        itunesApplication: iTunesApplicationWrapperType = SBApplication.pch_iTunes(),
        notificationCenter: DistributedNotificationCenterType = DistributedNotificationCenter.default()
    ) {
        self.itunesApplication = itunesApplication
        self.notificationCenter = notificationCenter

        setupNotificationObserver()
        updatePlayer()
    }

    deinit {
        notificationCenter.remove(observer: observer)
    }
}

// MARK: - Private stuff

fileprivate extension iTunes {
    func setupNotificationObserver() {
        observer = notificationCenter.addObserver(forName: "\(iTunesBundleIdentifier).playerInfo") { [weak self] in
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

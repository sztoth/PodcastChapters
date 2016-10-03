//
//  iTunesApplicationWrapper.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iTunes.h"
#import "iTunesTrackWrapper.h"

FOUNDATION_EXPORT NSString * const _Nonnull iTunesBundleIdentifier;

typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStatePlaying,
    PlayerStatePaused,
    PlayerStateStopped,
    PlayerStateUnknown
};

@interface iTunesApplicationWrapper : NSObject

@property (assign, nonatomic, readonly) PlayerState playerState;
@property (assign, nonatomic, readonly) double playerPosition;

@property (strong, nonatomic, nullable, readonly) iTunesTrackWrapper *currentTrack;

- (instancetype _Nonnull)initWithItunesApplication:(iTunesApplication * _Nonnull)application;

@end

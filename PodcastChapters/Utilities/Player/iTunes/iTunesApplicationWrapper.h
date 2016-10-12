//
//  iTunesApplicationWrapper.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iTunesTypes.h"
#import "iTunesTrackWrapper.h"

FOUNDATION_EXPORT NSString * const _Nonnull iTunesBundleIdentifier;

@interface iTunesApplicationWrapper : NSObject

- (nonnull instancetype)initWithItunesApplication:(nonnull id<iTunesApplicationType>)application;

@end

#pragma mark - iTunesApplicationWrapperType

typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStatePlaying,
    PlayerStatePaused,
    PlayerStateStopped,
    PlayerStateUnknown
};

@protocol iTunesApplicationWrapperType <NSObject>

@property (assign, nonatomic, readonly) PlayerState playerState;
@property (assign, nonatomic, readonly) double playerPosition;
@property (strong, nonatomic, readonly, nullable) id<iTunesTrackWrapperType> currentTrack;

@end

#pragma mark - iTunesApplicationWrapper's iTunesApplicationWrapperType extension

@interface iTunesApplicationWrapper (PCH) <iTunesApplicationWrapperType>

@property (assign, nonatomic, readonly) PlayerState playerState;
@property (assign, nonatomic, readonly) double playerPosition;
@property (strong, nonatomic, readonly, nullable) id<iTunesTrackWrapperType> currentTrack;

@end

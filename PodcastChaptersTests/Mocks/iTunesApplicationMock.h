//
//  iTunesApplicationMock.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iTunesTypes.h"
#import "iTunesTrackMock.h"

@interface iTunesApplicationMock : NSObject

@property (assign, nonatomic) iTunesEPlS mockPlayerState;
@property (assign, nonatomic) double mockPlayerPosition;
@property (strong, nonatomic, nullable) iTunesTrackMock *mockCurrentTrack;

@end

#pragma mark - Mock protocol

@interface iTunesApplicationMock (Mock) <iTunesApplicationType>

@property (readonly) iTunesEPlS playerState;
@property double playerPosition;
@property (copy, readonly, nullable) id<iTunesTrackType> currentTrack;

@end

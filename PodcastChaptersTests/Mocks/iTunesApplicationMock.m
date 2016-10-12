//
//  iTunesApplicationMock.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesApplicationMock.h"

@implementation iTunesApplicationMock

#pragma mark - Custom getters

- (double)playerPosition
{
    return self.mockPlayerPosition;
}

- (iTunesEPlS)playerState
{
    return self.mockPlayerState;
}

- (id<iTunesTrackType>)currentTrack
{
    return self.mockCurrentTrack;
}

#pragma mark - Setters we do not care about

- (void)setPlayerPosition:(double)playerPosition {}

@end

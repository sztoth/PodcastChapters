//
//  iTunesApplicationWrapper.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesApplicationWrapper.h"

NSString * const iTunesBundleIdentifier = @"com.apple.iTunes";

@interface iTunesApplicationWrapper ()

@property (assign, nonatomic, readwrite) PlayerState playerState;
@property (assign, nonatomic, readwrite) double playerPosition;

@property (strong, nonatomic, nullable, readwrite) iTunesTrackWrapper *currentTrack;
@property (strong, nonatomic, nonnull) iTunesApplication *application;

@end

@implementation iTunesApplicationWrapper

- (instancetype)initWithItunesApplication:(iTunesApplication *)application
{
    self = [super init];
    if (self) {
        _application = application;
    }

    return self;
}

- (PlayerState)playerState
{
    switch (self.application.playerState) {
        case iTunesEPlSPlaying: return PlayerStatePlaying;
        case iTunesEPlSPaused:  return PlayerStatePaused;
        case iTunesEPlSStopped: return PlayerStateStopped;

        default:                return PlayerStateUnknown;
    }
}

- (double)playerPosition
{
    return self.application.playerPosition;
}

- (iTunesTrackWrapper *)currentTrack
{
    NSString *identifier = self.application.currentTrack.persistentID;
    NSString *artist = self.application.currentTrack.artist;
    NSString *title = self.application.currentTrack.name;

    if (!identifier || !artist || !title) {
        return nil;
    }

    Boolean podcast = self.application.currentTrack.mediaKind == iTunesEMdKPodcast;
    NSImage *artwork = self.application.currentTrack.artworks.firstObject.data;

    return [[iTunesTrackWrapper alloc] initWithIdentifier:identifier
                                                  artwork:artwork
                                                   artist:artist
                                                    title:title
                                                  podcast:podcast];
}

@end

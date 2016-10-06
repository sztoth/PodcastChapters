//
//  iTunesTrackWrapper.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesTrackWrapper.h"

@interface iTunesTrackWrapper ()

@property (strong, nonatomic, readwrite, nonnull) NSString *identifier;
@property (strong, nonatomic, readwrite, nullable) NSImage *artwork;
@property (strong, nonatomic, readwrite, nonnull) NSString *artist;
@property (strong, nonatomic, readwrite, nonnull) NSString *title;
@property (assign, nonatomic, readwrite, getter=isPodcast) Boolean podcast;

@end

@implementation iTunesTrackWrapper

- (instancetype)initWithIdentifier:(NSString *)identifier
                           artwork:(NSImage * _Nullable)artwork
                            artist:(NSString *)artist
                             title:(NSString *)title
                           podcast:(Boolean)podcast
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _artwork = artwork;
        _artist = artist;
        _title = title;
        _podcast = podcast;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (!object) {
        return NO;
    }

    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[iTunesTrackWrapper class]]) {
        return NO;
    }

    return [self isEqualToTrack:object];
}

- (NSUInteger)hash
{
    return [self.identifier hash];
}

- (BOOL)isEqualToTrack:(iTunesTrackWrapper *)track
{
    return [self.identifier isEqualToString:track.identifier];
}

@end

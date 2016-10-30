//
//  iTunesTrackWrapper.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesTrackWrapper.h"

@interface iTunesTrackWrapper ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSImage *artwork;
@property (strong, nonatomic, readwrite) NSString *artist;
@property (strong, nonatomic, readwrite) NSString *title;
@property (assign, nonatomic, readwrite, getter=isPodcast) BOOL podcast;

@end

@implementation iTunesTrackWrapper

// codebeat:disable[ARITY]
- (instancetype)initWithIdentifier:(NSString *)identifier
                           artwork:(NSImage *)artwork
                            artist:(NSString *)artist
                             title:(NSString *)title
                           podcast:(BOOL)podcast
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
// codebeat:enable[ARITY]

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

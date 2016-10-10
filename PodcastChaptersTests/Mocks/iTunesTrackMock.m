//
//  iTunesTrackMock.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesArtworkMock.h"
#import "iTunesTrackMock.h"

@interface iTunesTrackMock ()

@property (copy, nonatomic) NSString *mockPersistentID;
@property (copy, nonatomic) NSString *mockArtist;
@property (copy, nonatomic) NSString *mockTitle;
@property (assign, nonatomic) iTunesEMdK mockMediaKind;
@property (copy, nonatomic) NSArray *mockArtworks;

@end

@implementation iTunesTrackMock

- (instancetype)initWithMockPersistentID:(NSString *)mockPersistentID
                              mockArtist:(NSString *)mockArtist
                               mockTitle:(NSString *)mockTitle
                           mockMediaKind:(iTunesEMdK)mockMediaKind
                             mockArtwork:(NSArray<NSImage *> *)mockArtworks
{
    self = [super init];
    if (self) {
        _mockPersistentID = mockPersistentID;
        _mockArtist = mockArtist;
        _mockTitle = mockTitle;
        _mockMediaKind = mockMediaKind;
        _mockArtworks = mockArtworks;
    }

    return self;
}

#pragma mark - Custom getters

- (NSString *)persistentID
{
    return self.mockPersistentID;
}

- (NSString *)artist
{
    return self.mockArtist;
}

- (NSString *)name
{
    return self.mockTitle;
}

- (iTunesEMdK)mediaKind
{
    return self.mockMediaKind;
}

- (SBElementArray<id<iTunesArtworkType>> *)artworks
{
    NSMutableArray *artworks = [NSMutableArray array];
    for (NSImage *image in self.mockArtworks) {
        iTunesArtworkMock *artwork = [[iTunesArtworkMock alloc] initWithImage:image];
        [artworks addObject:artwork];
    }

    return [[SBElementArray alloc] initWithArray:[NSArray arrayWithArray:artworks]];
}

#pragma mark - Setters we do not care about

- (void)setArtist:(NSString *)artist {}

- (void)setName:(NSString *)name {}

- (void)setMediaKind:(iTunesEMdK)mediaKind {}

@end

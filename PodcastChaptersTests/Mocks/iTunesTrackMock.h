//
//  iTunesTrackMock.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 09..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iTunesTypes.h"

@interface iTunesTrackMock : NSObject

- (nullable instancetype)initWithMockPersistentID:(nullable NSString *)mockPersistentID
                                       mockArtist:(nullable NSString *)mockArtist
                                        mockTitle:(nullable NSString *)mockTitle
                                    mockMediaKind:(iTunesEMdK)mockMediaKind
                                      mockArtwork:(nullable NSArray<NSImage *> *)mockArtwork;

@end

#pragma mark - Mock protocol

@interface iTunesTrackMock (Mock) <iTunesTrackType>

@property (copy, readonly, nullable) NSString *persistentID;
@property (copy, nullable) NSString *artist;
@property (copy, nullable) NSString *name;
@property iTunesEMdK mediaKind;

- (nullable SBElementArray<id<iTunesArtworkType>> *)artworks;

@end

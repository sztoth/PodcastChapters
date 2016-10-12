//
//  iTunesArtworkMock.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 10..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesTypes.h"

@interface iTunesArtworkMock : NSObject

- (nonnull instancetype)initWithImage:(nonnull NSImage *)image;

@end

#pragma mark - Mock protocol

@interface iTunesArtworkMock (Mock) <iTunesArtworkType>

@property (copy, nullable) NSImage *data;

@end

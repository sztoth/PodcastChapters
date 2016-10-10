//
//  iTunesArtworkMock.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 10..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunesArtworkMock.h"

@interface iTunesArtworkMock ()

@property (strong, nonatomic) NSImage *image;

@end

@implementation iTunesArtworkMock

- (instancetype)initWithImage:(NSImage *)image
{
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

#pragma mark - Custom getter

- (NSImage *)data
{
    return self.image;
}

#pragma mark - Setter we do not care about

- (void)setData:(NSImage *)data {}

@end

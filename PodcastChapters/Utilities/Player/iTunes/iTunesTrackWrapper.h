//
//  iTunesTrackWrapper.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTunesTrackWrapper : NSObject

- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier
                                   artwork:(nullable NSImage *)artwork
                                    artist:(nonnull NSString *)artist
                                     title:(nonnull NSString *)title
                                   podcast:(BOOL)podcast;

@end

#pragma mark - iTunesTrackWrapperType

@protocol iTunesTrackWrapperType <NSObject>

@property (strong, nonatomic, readonly, nonnull) NSString *identifier;
@property (strong, nonatomic, readonly, nullable) NSImage *artwork;
@property (strong, nonatomic, readonly, nonnull) NSString *artist;
@property (strong, nonatomic, readonly, nonnull) NSString *title;
@property (assign, nonatomic, readonly, getter=isPodcast) BOOL podcast;

@end

#pragma mark - iTunesTrackWrapper's iTunesTrackWrapperType extension

@interface iTunesTrackWrapper (PCH) <iTunesTrackWrapperType>

@property (strong, nonatomic, readonly, nonnull) NSString *identifier;
@property (strong, nonatomic, readonly, nullable) NSImage *artwork;
@property (strong, nonatomic, readonly, nonnull) NSString *artist;
@property (strong, nonatomic, readonly, nonnull) NSString *title;
@property (assign, nonatomic, readonly, getter=isPodcast) BOOL podcast;

@end

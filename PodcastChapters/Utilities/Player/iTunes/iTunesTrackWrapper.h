//
//  iTunesTrackWrapper.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTunesTrackWrapper : NSObject

@property (strong, nonatomic, readonly, nonnull) NSString *identifier;
@property (strong, nonatomic, readonly, nullable) NSImage *artwork;
@property (strong, nonatomic, readonly, nonnull) NSString *artist;
@property (strong, nonatomic, readonly, nonnull) NSString *title;
@property (assign, nonatomic, readonly, getter=isPodcast) Boolean podcast;

- (instancetype _Nonnull)initWithIdentifier:(NSString * _Nonnull)identifier
                                    artwork:(NSImage * _Nullable)artwork
                                     artist:(NSString * _Nonnull)artist
                                      title:(NSString * _Nonnull)title
                                    podcast:(Boolean)podcast;

@end

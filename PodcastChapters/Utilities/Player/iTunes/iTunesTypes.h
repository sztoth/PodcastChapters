//
//  iTunesTypes.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 10..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>

#import "iTunesEnums.h"

@protocol iTunesArtworkType <NSObject>

@property (copy, nullable) NSImage *data;

@end

@protocol iTunesTrackType <NSObject>

@property (copy, readonly, nullable) NSString *persistentID;
@property (copy, nullable) NSString *artist;
@property (copy, nullable) NSString *name;
@property iTunesEMdK mediaKind;

- (nullable SBElementArray<id<iTunesArtworkType>> *)artworks;

@end

@protocol iTunesApplicationType <NSObject>

@property (readonly) iTunesEPlS playerState;
@property double playerPosition;
@property (copy, readonly, nullable) id<iTunesTrackType> currentTrack;

@end

//
//  SBApplication+PCH.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>

#import "iTunesApplicationWrapper.h"

@interface SBApplication (PCH)

+ (iTunesApplicationWrapper * _Nonnull)pch_iTunes;

@end

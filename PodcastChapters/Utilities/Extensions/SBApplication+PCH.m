//
//  SBApplication+PCH.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import "iTunes.h"
#import "SBApplication+PCH.h"

@implementation SBApplication (PCH)

+ (iTunesApplicationWrapper *)pch_iTunes
{
    iTunesApplication *app = (iTunesApplication *)[SBApplication applicationWithBundleIdentifier:iTunesBundleIdentifier];
    return [[iTunesApplicationWrapper alloc] initWithItunesApplication:app];
}

@end

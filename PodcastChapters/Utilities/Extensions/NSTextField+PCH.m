//
//  NSTextField+PCH.m
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 03. 13..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

#import <objc/runtime.h>

#import "NSTextField+PCH.h"

static void (*originalDrawRectIMP)(id, SEL, NSRect);

static void fixedDrawRect (NSTextView *self, SEL _cmd, NSRect rect) {
    CGContextRef context = NSGraphicsContext.currentContext.graphicsPort;

    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);

    if (self.superview) {
        if (self.superview.window != nil) {
            NSRect windowRect = [self convertRect:self.frame toView:nil];
            NSRect windowBackingRect = [self backingAlignedRect:windowRect options:NSAlignAllEdgesNearest];
            self.frame = [self convertRect:windowBackingRect fromView:nil];
        }
        else {
            CGFloat scaleFactor = NSScreen.mainScreen.backingScaleFactor;
            CGAffineTransform transformToBacking = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

            CGRect backingRect = CGRectApplyAffineTransform(self.frame, transformToBacking);
            backingRect = NSIntegralRectWithOptions(backingRect, NSAlignAllEdgesNearest);
            self.frame = CGRectApplyAffineTransform(backingRect, CGAffineTransformInvert(transformToBacking));
        }
    }
    
    originalDrawRectIMP(self, _cmd, rect);
}

@implementation NSTextField (PCH)

+ (void)load
{
    Method drawRect = class_getInstanceMethod(self, @selector(drawRect:));
    originalDrawRectIMP = (void (*)(id, SEL, NSRect))method_getImplementation(drawRect);

    method_setImplementation(drawRect, (IMP)&fixedDrawRect);
}

@end

//
//  NSTimer+CrossBlockSupport.m
//  UIScrollView
//
//  Created by chaobai on 16/1/19.
//  Copyright © 2016年 chaobai. All rights reserved.
//

#import "NSTimer+CrossBlockSupport.h"

@implementation NSTimer (CrossBlockSupport)

+ (NSTimer *)crossScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}


+ (void)blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}

@end

//
//  NSTimer+CrossBlockSupport.h
//  UIScrollView
//
//  Created by chaobai on 16/1/19.
//  Copyright © 2016年 chaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CrossBlockSupport)

+ (NSTimer *)crossScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end

//
//  CrossScrollView.h
//  UIScrollView
//
//  Created by chaobai on 16/1/6.
//  Copyright © 2016年 chaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrossScrollView;

@protocol CrossScrollViewDelegate <NSObject>

@optional

-(void)didClickPage:(CrossScrollView *)view atIndex:(NSInteger)index;

@end

@interface CrossScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<CrossScrollViewDelegate> delegate;

+ (instancetype)CrossScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray*)imageUrl;
+ (instancetype)CrossScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrl timerInterval:(NSTimeInterval)timerInterval;

- (void)pauseTimer;

- (void)startTimer;
@end

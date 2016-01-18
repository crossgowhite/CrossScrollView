//
//  CrossScrollView.m
//  UIScrollView
//
//  Created by chaobai on 16/1/6.
//  Copyright © 2016年 chaobai. All rights reserved.
//

#import "CrossScrollView.h"

@interface CrossScrollView ()
{
    float _viewWidth;
    float _viewHeight;
}

@property (nonatomic, retain) NSArray *                     imageViewArray;
@property (nonatomic, retain) UIScrollView *                scrollView;
@property (nonatomic, retain) UIPageControl *               pageController;
@property (nonatomic, retain) UITapGestureRecognizer *      tap;
@property (nonatomic, retain) NSTimer *                     autoScrollTimer;
@property (nonatomic, assign) NSInteger                     currentPage;
@end

@implementation CrossScrollView

#pragma mark - Life Cycle
+ (instancetype)CrossScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray*)imageUrl
{
    CrossScrollView * scrollView = [[CrossScrollView alloc]initWithFrame:frame];
    scrollView.imageViewArray = imageUrl;
    [scrollView configScrollView];
    return scrollView;
}

+ (instancetype)CrossScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrl timerInterval:(NSTimeInterval)timerInterval
{
    CrossScrollView * scrollView = [[CrossScrollView alloc]initWithFrame:frame];
    scrollView.imageViewArray = imageUrl;
    [scrollView configScrollView];
    [scrollView configTimerWithTimerInterval:timerInterval];
    return scrollView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height;
    }
    
    return self;
}

- (void)dealloc
{
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
}

#pragma mark - Public Method
- (void)pauseTimer
{
    if ([_autoScrollTimer isValid]) {
        [_autoScrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)startTimer
{
    if (![_autoScrollTimer isValid]) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoSCroll) userInfo:nil repeats:YES];
    }
}

#pragma mark - Private Method
- (void)configScrollView
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageController];
    
    [self.scrollView addGestureRecognizer:self.tap];
    
    [self loadData];
}

- (void)configTimerWithTimerInterval:(NSTimeInterval)timerInterval
{
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(autoSCroll) userInfo:nil repeats:YES];
}

-(void)loadData
{
    //add last image view at first
    UIImageView * firstImageView = [[UIImageView alloc]init];
    firstImageView.image = [_imageViewArray lastObject];
    firstImageView.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
    [_scrollView addSubview:firstImageView];
    
    int i;
    for (i = 1; i <= _imageViewArray.count; i++) {
        UIImageView * view = [[UIImageView alloc]init];
        view.image = [_imageViewArray objectAtIndex:i-1];
        view.frame = CGRectMake(i* _viewWidth, 0, _viewWidth, _viewHeight);
        [_scrollView addSubview:view];
    }
    
    //add first image view at last
    UIImageView * lastImageView = [[UIImageView alloc]init];
    lastImageView.image = [_imageViewArray firstObject] ;
    lastImageView.frame = CGRectMake(i*_viewWidth, 0, _viewWidth, _viewHeight);
    [_scrollView addSubview:lastImageView];
    
    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
}

- (void)autoSCroll
{
    if (_currentPage == _imageViewArray.count-1) {
        _currentPage = 0;
    }
    else{
        _currentPage ++;
    }
    
    _pageController.currentPage = _currentPage;
    [_scrollView setContentOffset: CGPointMake((_currentPage+1) * _viewWidth, 0) animated:YES];
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoSCroll) userInfo:nil repeats:YES];
    }
    
    float x = _scrollView.contentOffset.x;

    if (x <= 0)
    {
        if (_currentPage-1<0)
        {
            _currentPage = _imageViewArray.count-1;
            _scrollView.contentOffset = CGPointMake(_imageViewArray.count * _viewWidth, 0);
        }
    }

    else if (x>=_viewWidth*(_imageViewArray.count+1) && _currentPage == _imageViewArray.count-1)
    {
        _currentPage = 0;
        _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
    }
    
    else
    {
        _currentPage = _scrollView.contentOffset.x /_viewWidth -1;
    }
    
    _pageController.currentPage = _currentPage;
}


#pragma mark - Event Response
- (void)handleTap:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [self.delegate didClickPage:self atIndex:_currentPage];
    }
}

#pragma mark - Getter/Setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_viewWidth * (_imageViewArray.count+2), 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [_scrollView setPagingEnabled:YES];
    }
    return _scrollView;
}

- (UIPageControl *)pageController
{
    if (_pageController == nil) {
        _pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _viewHeight -30, _viewWidth, 30)];
        _pageController.userInteractionEnabled = NO;
        _pageController.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageController.pageIndicatorTintColor = [UIColor blackColor];
        _pageController.numberOfPages = _imageViewArray.count;
        _pageController.currentPage = 0;
    }
    return _pageController;
}

- (UITapGestureRecognizer *)tap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
    }
    return _tap;
}



@end

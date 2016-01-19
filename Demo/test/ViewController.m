//
//  ViewController.m
//  test
//
//  Created by chaobai on 16/1/18.
//  Copyright © 2016年 chaobai. All rights reserved.
//

#import "ViewController.h"
#import "CrossScrollView.h"

@interface ViewController () <CrossScrollViewDelegate>

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i=1; i<=4; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [array addObject:image];
    }
    CrossScrollView * view = [CrossScrollView CrossScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400) imageUrl:array timerInterval:2];
    view.delegate = self;
    [self.view addSubview:view];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickPage:(CrossScrollView *)view atIndex:(NSInteger)index
{
    NSLog(@"click page %ld",(long)index);
}

@end

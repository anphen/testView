//
//  ChildViewController.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/26.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentlabel.text = [NSString stringWithFormat:@"%li", (long)self.index];
    NSLog(@"===== %s ===== %li ===", __func__, (long)self.index);
}

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

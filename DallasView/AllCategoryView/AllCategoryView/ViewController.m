//
//  ViewController.m
//  AllCategoryView
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "AllCategoryView.h"

@interface ViewController ()

@property (nonatomic, strong) AllCategoryView *categoryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    }

- (IBAction)testAction:(id)sender {
    if (!self.categoryView) {
        self.categoryView  = [[AllCategoryView alloc]initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200) ItemArray:@[@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品", @"水", @"空调", @"装潢用品", @"生活大电器", @"电水壶",@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品", @"水", @"空调", @"装潢用品", @"生活大电器", @"电水壶"]];
        self.categoryView.backgroundColor = [UIColor grayColor];
        self.categoryView.lineHeight = 30;
        [self.view addSubview: self.categoryView];
    }
    
    if (self.categoryView.frame.origin.y < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryView.frame = CGRectMake(0, 0, self.categoryView.frame.size.width, self.categoryView.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.categoryView.frame = CGRectMake(0, 200, self.categoryView.frame.size.width, self.categoryView.frame.size.height);
        }];
    }
    
}

@end

//
//  ViewController.m
//  TestCountDownView
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "SNCouponCenterCountDownView.h"
#import "Masonry.h"

@interface ViewController ()<SNCouponCenterCountDownViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *countDownView;
@property (nonatomic, strong) SNCouponCenterCountDownView *ccCountDownView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.countDownView addSubview:self.ccCountDownView];
    [self.ccCountDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
    }];
}

- (SNCouponCenterCountDownView *)ccCountDownView
{
    if (!_ccCountDownView) {
        _ccCountDownView = [SNCouponCenterCountDownView countDownView];
        _ccCountDownView.delegate = self;
        NSString *endDateString = @"20170414100000";
        _ccCountDownView.endDateString = endDateString;
    }
    return _ccCountDownView;
}
- (void)currentLocateToEndDate:(NSDateComponents *)dateComponent{
    NSLog(@"%li,%li,%li",(long)dateComponent.hour,(long)dateComponent.minute,(long)dateComponent.second);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

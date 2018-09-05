//
//  ViewController.m
//  testProgressBar
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "SNCouponCenterProgressBar.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, strong) SNCouponCenterProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.progressBar) {
        self.progressBar = [SNCouponCenterProgressBar progressBar];
        self.progressBar.barColor = [UIColor orangeColor];
        self.progressBar.backgroundImage = [[UIImage imageNamed:@"0.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        self.progressBar.backgroundImageColor = [UIColor redColor];
        [self.view addSubview:self.progressBar];
        [self.progressView addSubview:self.progressBar];
        [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.mas_equalTo(0);
        }];
    }
    else{
        self.progressBar.rate = 0.8;
    }
}

@end

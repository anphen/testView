//
//  ViewController.m
//  MessageVerify
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "SNMessegeVerifyView.h"

@interface ViewController ()<SNMessegeVerifyViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SNMessegeVerifyView *view = [SNMessegeVerifyView showAtView:self.view];
    view.delegate = self;
}

- (void)didClickhiddenButton:(SNMessegeVerifyView *)SNMessegeVerifyView{
    
}
- (void)didClickhandleButton:(SNMessegeVerifyView *)SNMessegeVerifyView{
    
}
- (void)didClickverityCodeButton:(SNMessegeVerifyView *)SNMessegeVerifyView{
    
}

@end

//
//  SNCouponCenterProgressBar.h
//  testProgressBar
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNCouponCenterProgressBar : UIView

+ (SNCouponCenterProgressBar *)progressBar;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundImageColor;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat orginWidth;

@end

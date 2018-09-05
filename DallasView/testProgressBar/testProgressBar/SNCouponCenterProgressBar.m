//
//  SNCouponCenterProgressBar.m
//  testProgressBar
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "SNCouponCenterProgressBar.h"

@interface SNCouponCenterProgressBar()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewWidthConstrait;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation SNCouponCenterProgressBar

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundImageView.layer.masksToBounds = YES;
}

+ (SNCouponCenterProgressBar *)progressBar{
    SNCouponCenterProgressBar *bar = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return bar;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setBarColor:(UIColor *)barColor{
    _barColor = barColor;
    _barView.backgroundColor = barColor;
}

- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor{
    _backgroundImageColor = backgroundImageColor;
    self.coverView.backgroundColor = backgroundImageColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_orginWidth == 0.0) {
        _orginWidth = self.frame.size.width - 2;
        if (self.rate != 0.0) {
            self.rate = self.rate;
        }
    }
    self.barView.layer.cornerRadius = self.barView.frame.size.height * 0.5;
    self.coverView.layer.cornerRadius = self.coverView.frame.size.height * 0.5;
}

- (void)setRate:(CGFloat)rate
{
    _rate = rate;
    self.barViewWidthConstrait.constant = (self.orginWidth - 2) * rate;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

@end

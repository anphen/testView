//
//  SNMessegeVerifyView.m
//  MessageVerify
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "SNMessegeVerifyView.h"
#import "Masonry.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define Get375Height(h)  (h) * kScreenWidth / 375


@interface SNMessegeVerifyView()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *parentView;

@end

@implementation SNMessegeVerifyView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabelTopConstraint.constant = Get375Height(25);
    self.telTitleLabelContraint.constant = Get375Height(26);
    self.textFieldTopConstraint.constant = Get375Height(10);
    self.imageViewTopConstraint.constant = Get375Height(27);
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:12],
                                 };
    CGSize textSize = [self.verityCodeButton.titleLabel.text sizeWithAttributes:attributes];
    [self.verityCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width + 10);
    }];
    self.verityCodeButton.layer.cornerRadius = 5;
    [self layoutIfNeeded];
}

- (IBAction)hiddenButtonAction:(id)sender {
    [self hidden];
    if ([self.delegate respondsToSelector:@selector(didClickhiddenButton:)]) {
        [self.delegate didClickhiddenButton:self];
    }
}

- (IBAction)handleButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickhandleButton:)]) {
        [self.delegate didClickhandleButton:self];
    }
}

- (IBAction)verifyCodeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickverityCodeButton:)]) {
        [self.delegate didClickverityCodeButton:self];
    }
}

+ (SNMessegeVerifyView *)showAtView:(UIView *)superView{
    SNMessegeVerifyView * verifyView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    verifyView.frame = CGRectMake(Get375Height(40), (superView.frame.size.height - (superView.frame.size.width - Get375Height(80)) * 55/56) * 0.5 - 40, superView.frame.size.width - Get375Height(80), (superView.frame.size.width - 80) * 55/56);
    verifyView.parentView = superView;
    [superView addSubview:verifyView.coverView];
    [superView addSubview:verifyView];
    return verifyView;
}

- (void)hidden{
    [self.coverView removeFromSuperview];
    [self removeFromSuperview];
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.parentView.frame.size.width, self.parentView.frame.size.height)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.2;
    }
    return _coverView;
}

@end

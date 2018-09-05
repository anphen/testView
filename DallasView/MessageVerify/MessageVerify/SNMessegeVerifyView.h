//
//  SNMessegeVerifyView.h
//  MessageVerify
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNMessegeVerifyView;
@protocol SNMessegeVerifyViewDelegate <NSObject>

@optional
- (void)didClickhiddenButton:(SNMessegeVerifyView *)SNMessegeVerifyView;
- (void)didClickhandleButton:(SNMessegeVerifyView *)SNMessegeVerifyView;
- (void)didClickverityCodeButton:(SNMessegeVerifyView *)SNMessegeVerifyView;

@end

@interface SNMessegeVerifyView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telTitleLabelContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleButton;

@property (weak, nonatomic) IBOutlet UIButton *verityCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, weak) id<SNMessegeVerifyViewDelegate> delegate;
- (IBAction)handleButtonAction:(id)sender;

- (IBAction)verifyCodeButtonAction:(id)sender;

- (IBAction)hiddenButtonAction:(id)sender;

+ (SNMessegeVerifyView *)showAtView:(UIView *)superView;

- (void)hidden;

@end

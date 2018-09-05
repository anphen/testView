//
//  ZXCycleImageView.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/28.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCycleImageView : UIView

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, strong) UIColor *pageControlTintColor;
@property (nonatomic, strong) UIColor *pageControlCurrentTintColor;


@end

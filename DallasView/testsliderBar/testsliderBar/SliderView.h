//
//  SliderView.h
//  testsliderBar
//
//  Created by zhaoxu on 2017/4/10.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderView;
@protocol SliderViewDelegate <NSObject>

- (void)sliderView:(SliderView *)sliderView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface SliderView : UIView

@property (nonatomic, strong) NSArray *itemTitleArray;
@property (nonatomic, weak) id<SliderViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat itemInteval;
@property (nonatomic, assign) CGFloat indicateViewHeight;
@property (nonatomic, strong) UIColor *itemSelectedColor;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, assign) NSInteger originIndex;
@property (nonatomic, strong) UIColor *indicateViewColor;

@end

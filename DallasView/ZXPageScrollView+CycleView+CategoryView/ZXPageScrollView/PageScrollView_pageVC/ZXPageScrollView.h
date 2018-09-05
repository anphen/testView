//
//  ZXPageScrollView.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/26.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXPageScrollView;

@protocol ZXPageScrollViewDelegate <NSObject>

- (void)ZXPageScrollView:(ZXPageScrollView *)pageScrollView
willTransitionToViewController:(UIViewController *)nextViewController
    fromViewController:(UIViewController *)currentViewController;

- (void)ZXPageScrollView:(ZXPageScrollView *)pageScrollView didFinishTransition:(BOOL)finished;

@end

@protocol ZXPageScrollViewDataSource <NSObject>

- (NSInteger)numberOfItemInZXPageScrollView:(ZXPageScrollView *)pageScrollView;

@optional
//下面两个方法实现一个即可
- (UIView *)ZXPageScrollView:(ZXPageScrollView *)pageScrollView viewInIndex:(NSInteger)index;

- (UIViewController *)ZXPageScrollView:(ZXPageScrollView *)pageScrollView viewControllInIndex:(NSInteger)index;

@end

@interface ZXPageScrollView : UIView

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, strong) UIColor *pageControlTintColor;
@property (nonatomic, strong) UIColor *pageControlCurrentTintColor;
//default NO
@property (nonatomic, assign) BOOL infiniteLoop;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<ZXPageScrollViewDelegate>)delegate
                   dataSource:(id<ZXPageScrollViewDataSource>)dataSource;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<ZXPageScrollViewDelegate>)delegate
                   dataSource:(id<ZXPageScrollViewDataSource>)dataSource
                  originIndex:(NSInteger)index;

- (BOOL)scrollPageViewToIndex:(NSInteger)index;

- (BOOL)scrollPageViewToIndex:(NSInteger)index animation:(BOOL)animation;

- (NSInteger)getCurrentIndex;

- (UIView *)getCurrentView;

- (UIViewController *)getCurrentViewController;

@end

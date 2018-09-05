//
//  ZXCategoryView.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXCategoryView;

typedef void(^didSelectItemBlock)(NSInteger index, ZXCategoryView *categoryView);

@interface ZXCategoryView : UIView

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat itemSizeScale;
@property (nonatomic, assign) CGFloat upDownInset;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, assign) NSInteger originIndex;
@property (nonatomic, strong) UIColor *indicateViewColor;


@property (nonatomic, strong) NSArray<NSString *> *itemArray;

- (instancetype)initWithFrame:(CGRect)frame didSelectItemBlock:(didSelectItemBlock)selectBlock;
- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation;

@end

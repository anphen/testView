//
//  AllCategoryView.h
//  SuningEBuy
//
//  Created by zhaoxu on 2017/4/11.
//  Copyright © 2017年 苏宁易购. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllCategoryViewDelegate <NSObject>

- (void)didSelectedItemAtIndex:(NSInteger)index;

@end

@interface AllCategoryView : UIView

@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id<AllCategoryViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray;

@end

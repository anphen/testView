//
//  childVIew.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface childVIew : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *dataArray;

- (void)fetchData;

@end

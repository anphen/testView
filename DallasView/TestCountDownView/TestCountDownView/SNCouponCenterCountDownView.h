//
//  SNCouponCenterCountDownView.h
//  TestCountDownView
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNCouponCenterCountDownViewDelegate <NSObject>

- (void)currentLocateToEndDate:(NSDateComponents *)dateComponent;

@end

@interface SNCouponCenterCountDownView : UIView

@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSString *endDateString;//20170414100000
@property (nonatomic, weak) id<SNCouponCenterCountDownViewDelegate> delegate;

+ (SNCouponCenterCountDownView *)countDownView;

@end

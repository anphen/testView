//
//  SNCouponCenterCountDownView.m
//  TestCountDownView
//
//  Created by zhaoxu on 2017/4/13.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "SNCouponCenterCountDownView.h"

@interface SNCouponCenterCountDownView()

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *miniLabel;
@property (weak, nonatomic) IBOutlet UILabel *seclabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SNCouponCenterCountDownView

+ (SNCouponCenterCountDownView *)countDownView{
    SNCouponCenterCountDownView *coundDownView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return coundDownView;
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self updateTime];
        }];
    }
    return _timer;
}

- (void)setEndDateString:(NSString *)endDateString
{
    NSString *yearStr = [endDateString substringWithRange:NSMakeRange(0, 4)];
    NSString *monthStr = [endDateString substringWithRange:NSMakeRange(4, 2)];
    NSString *dayStr = [endDateString substringWithRange:NSMakeRange(6, 2)];
    NSString *hourStr = [endDateString substringWithRange:NSMakeRange(8, 2)];
    NSString *minStr = [endDateString substringWithRange:NSMakeRange(10, 2)];
    NSString *secStr = [endDateString substringWithRange:NSMakeRange(12, 2)];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:[yearStr integerValue]];
    [comps setMonth:[monthStr integerValue]];
    [comps setDay:[dayStr integerValue]];
    [comps setHour:[hourStr integerValue]];
    [comps setMinute:[minStr integerValue]];
    [comps setSecond:[secStr integerValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:comps];
    self.endDate = date;
}

- (void)updateTime{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:_endDate options:0];
    if (dateComponent.hour < 10) {
         self.hourLabel.text = [NSString stringWithFormat:@"0%li", (long)dateComponent.hour];
    }
    else{
        self.hourLabel.text = [NSString stringWithFormat:@"%li", (long)dateComponent.hour];
    }
    if (dateComponent.minute < 10) {
        self.miniLabel.text = [NSString stringWithFormat:@"0%li", (long)dateComponent.minute];
    }
    else{
        self.miniLabel.text = [NSString stringWithFormat:@"%li", (long)dateComponent.minute];
    }
    if (dateComponent.second < 10) {
        self.seclabel.text = [NSString stringWithFormat:@"0%li", (long)dateComponent.second];
    }
    else{
        self.seclabel.text = [NSString stringWithFormat:@"%li", (long)dateComponent.second];
    }
    if ([self.delegate respondsToSelector:@selector(currentLocateToEndDate:)]) {
        [self.delegate currentLocateToEndDate:dateComponent];
    }
}


@end

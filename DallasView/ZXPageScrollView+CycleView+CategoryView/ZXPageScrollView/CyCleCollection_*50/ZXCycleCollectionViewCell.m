//
//  ZXCycleCollectionViewCell.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/28.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXCycleCollectionViewCell.h"

@interface ZXCycleCollectionViewCell()

@property (nonatomic, strong) UIImageView *mainImageView;

@end

@implementation ZXCycleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainImageView];
    }
    return self;
}

- (UIImageView *)mainImageView
{
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainImageView.backgroundColor = [UIColor greenColor];
    }
    return _mainImageView;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.mainImageView.image = [UIImage imageNamed:imageName];
}

@end

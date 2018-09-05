//
//  AllCategoryCell.m
//  SuningEBuy
//
//  Created by zhaoxu on 2017/4/11.
//  Copyright © 2017年 苏宁易购. All rights reserved.
//

#import "AllCategoryCell.h"
#import "UIColor+SNFoundation.h"

@interface AllCategoryCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AllCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recover) name:@"RecoverCellState" object:nil];
    // Initialization code
}

- (void)recover{
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)changeState{
    self.contentLabel.textColor = [UIColor colorWithHexString:@"ff6600"];
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.contentLabel.text = text;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

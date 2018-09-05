//
//  ChildViewController.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/26.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController

- (instancetype)initWithIndex:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;


@end

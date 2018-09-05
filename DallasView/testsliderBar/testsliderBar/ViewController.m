//
//  ViewController.m
//  testsliderBar
//
//  Created by zhaoxu on 2017/4/10.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"


@interface ViewController ()<SliderViewDelegate>

@property (nonatomic, strong) SliderView *sv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.sv) {
        self.sv = [[SliderView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
        self.sv.delegate = self;
        self.sv.originIndex = 2;
        self.sv.itemTitleArray = @[@"哈哈哈",@"哈哈",@"哈哈哈哈",@"哈哈哈",@"哈哈",@"哈哈哈哈",@"哈哈哈",@"哈哈哈哈",@"哈哈"];
        NSLog(@"%li", (long)self.sv.selectedIndex);
    }
    else{
        self.sv.selectedIndex = arc4random() % 10;
        NSLog(@"%li", (long)self.sv.selectedIndex);
    }
    [self.view addSubview:self.sv];
    
}

- (void)sliderView:(SliderView *)sliderView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"===%li", (long)self.sv.selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

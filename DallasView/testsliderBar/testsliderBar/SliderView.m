//
//  SliderView.m
//  testsliderBar
//
//  Created by zhaoxu on 2017/4/10.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "SliderView.h"

@interface ItemModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) CGFloat itemLength;

@end

@implementation ItemModel

@end

@interface SliderView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, strong) NSMutableArray *subButtonArray;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) UIView *indicateView;

@property (nonatomic, copy) void(^completeBlock)();

@end

@implementation SliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemModelArray = [[NSMutableArray alloc]init];
        _subButtonArray = [[NSMutableArray alloc]init];
        _indicateViewColor = [UIColor redColor];
        _indicateViewHeight = 2;
        _itemInteval = 30;
        _itemSelectedColor = [UIColor redColor];
        _itemNormalColor = [UIColor blackColor];
        _originIndex = 0;
        _selectedIndex = _originIndex;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self addSubview:self.mainScrollView];
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray
{
    _itemTitleArray  = itemTitleArray;
    [self packageTitle];
    [self configScrollView];
    UIButton *originButton = self.subButtonArray[_originIndex];
    [self buttonClick:originButton];
}


- (void)packageTitle
{
    for (int i = 0; i < self.itemTitleArray.count; i++) {
        NSString *text = self.itemTitleArray[i];
        ItemModel *model = [[ItemModel alloc]init];
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:14],
                                     };
        CGSize textSize = [text sizeWithAttributes:attributes];
        model.itemLength = textSize.width;
        model.text = text;
        [self.itemModelArray addObject:model];
    }
}

- (void)configScrollView
{
    CGFloat  currrentX = _itemInteval * 0.5;
    for (int i = 0; i < self.itemModelArray.count; i++) {
        ItemModel *model = self.itemModelArray[i];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(currrentX, 0, model.itemLength, self.frame.size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:_itemNormalColor forState:UIControlStateNormal];
        [button setTitle:model.text forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.itemModelArray.count -1) {
            currrentX = currrentX + model.itemLength + _itemInteval * 0.5;
        }
        else{
            currrentX = currrentX + model.itemLength + _itemInteval;
        }
        [self.subButtonArray addObject:button];
        [self.mainScrollView addSubview:button];
    }
    self.mainScrollView.contentSize = CGSizeMake(currrentX, 0);
    self.lastContentOffset =  self.mainScrollView.contentSize.width - self.frame.size.width;
}


- (void)buttonClick:(UIButton *)button{
    UIButton *lastButton = self.subButtonArray[self.selectedIndex];
    [lastButton setTitleColor:_itemNormalColor forState:UIControlStateNormal];
    NSInteger currentIndex =  [self.subButtonArray indexOfObject:button];
//    self.selectedIndex = currentIndex;
    __weak typeof(self)weakSelf = self;
    [self setSelectedIndex:currentIndex completeHandle:^{
        if ([weakSelf.delegate respondsToSelector:@selector(sliderView:didSelectedItemAtIndex:)]) {
            [weakSelf.delegate sliderView:weakSelf didSelectedItemAtIndex:currentIndex];
        }
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.completeBlock = nil;
    UIButton *lastButton = self.subButtonArray[self.selectedIndex];
    [lastButton setTitleColor:_itemNormalColor forState:UIControlStateNormal];
    _selectedIndex = selectedIndex;
    [self adjustIndicateViewToIndex:selectedIndex];
    [self adjustContentOffsetToIndex:selectedIndex - 1];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex completeHandle:(void(^)()) completeHandle{
    UIButton *lastButton = self.subButtonArray[self.selectedIndex];
    [lastButton setTitleColor:_itemNormalColor forState:UIControlStateNormal];
    self.selectedIndex = selectedIndex;
    if (completeHandle) {
        self.completeBlock = completeHandle;
    }
    [self adjustIndicateViewToIndex:selectedIndex];
    [self adjustContentOffsetToIndex:selectedIndex - 1];
}

- (void)adjustIndicateViewToIndex:(NSInteger)index{
    if (!_indicateView) {
        [self.mainScrollView addSubview:self.indicateView];
    }
    else{
        UIButton *button = self.subButtonArray[self.selectedIndex];
        [UIView animateWithDuration:0.2 animations:^{
             _indicateView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - _indicateViewHeight, button.frame.size.width, _indicateViewHeight);
        } completion:^(BOOL finished) {
            [button setTitleColor:_itemSelectedColor forState:UIControlStateNormal];
        }];
    }
}

- (UIView *)indicateView
{
    if (!_indicateView) {
        UIButton *button = self.subButtonArray[self.selectedIndex];
        [button setTitleColor:_itemSelectedColor forState:UIControlStateNormal];
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, self.frame.size.height - _indicateViewHeight, button.frame.size.width, _indicateViewHeight)];
        _indicateView.backgroundColor = self.indicateViewColor;
    }
    return _indicateView;
}

- (void)adjustContentOffsetToIndex:(NSInteger)index{
    if (index < 0) {
        [self setMianScrollContentOffset:CGPointMake(0, 0)];
        return;
    }
    UIButton *button = [self.subButtonArray objectAtIndex:index];
    CGFloat buttonX = button.frame.origin.x;
    CGFloat buttonOffset = buttonX - _itemInteval * 0.5;
    if (buttonOffset >= self.lastContentOffset) {
        [self setMianScrollContentOffset:CGPointMake(_lastContentOffset, 0)];
    }
    else{
        [self setMianScrollContentOffset:CGPointMake(buttonOffset, 0)];

    }
}

- (void)setMianScrollContentOffset:(CGPoint)point{
    [UIView animateWithDuration:0.2 animations:^{
        [self.mainScrollView setContentOffset:point];
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock();
        }
    }];
}

@end

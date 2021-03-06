//
//  ZXCategorySliderBar.m
//  ZXCollectionSliderBar
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ZXCategorySliderBar.h"
#import "ZXCategoryItemView.h"
#import "UIView+MJExtension.h"

CGFloat itemInteval = 30;

NSString *const RESETCOLORNOTIFICATION = @"RESETCOLORNOTIFICATION";

@interface ZXCategorySliderBar()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *itemWidthArray;
@property (nonatomic, strong) NSMutableArray *itemOriginXArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat lastContentOffsetX;

@end

@implementation ZXCategorySliderBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setUpUI];
    }
    return self;
}

- (void)commonInit{
    _originIndex = 0;
    _currentIndex = 0;
    _itemOriginXArray = [[NSMutableArray alloc]init];
    _itemWidthArray = [[NSMutableArray alloc]init];
    _isMoniteScroll = NO;
    _lastContentOffsetX = 0;
}

- (void)setUpUI{
    [self addSubview:self.mainCollectionView];
}

- (void)setSelectIndex:(NSInteger)index{
    self.currentIndex = index;
    [self adjustContentOffsetToIndex:index completeHanle:^{
        ZXCategoryItemView *itemView = (ZXCategoryItemView *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        itemView.contentLabel.textColor = [UIColor redColor];
        NSNotification *notification = [[NSNotification alloc]initWithName:RESETCOLORNOTIFICATION object:@"color" userInfo:@{@"color":[UIColor blackColor],@"index":@(self.currentIndex)}];
        [[NSNotificationCenter defaultCenter]postNotification:notification];

    } animation:YES];
}

- (void)setOriginIndex:(NSInteger)originIndex
{
    _originIndex = originIndex;
    _currentIndex = originIndex;
}

- (void)setMoniterScrollView:(UIScrollView *)moniterScrollView
{
    _moniterScrollView = moniterScrollView;
    _lastContentOffsetX = self.originIndex * moniterScrollView.mj_w;
}

- (void)adjustIndicateViewX:(UIScrollView *)scrollView direction:(NSString *)direction{
    if (!self.isMoniteScroll) {
        return;
    }
    CGFloat nextWitdth = 0.0;
    CGFloat nextOriginX = 0.0 ;
    if ([direction isEqualToString:@"向右"]) {
        NSInteger index = scrollView.contentOffset.x / scrollView.mj_w + 1;
        if (index >= self.itemArray.count || index < 0) {
            return;
        }
        CGFloat currentWidth = [self.itemWidthArray[index] floatValue];
        CGFloat currentOriginX = [self.itemOriginXArray[index] floatValue];
        if (index -1 < 0) {
            return;
        }
        nextWitdth = [self.itemWidthArray[index - 1] floatValue];
        nextOriginX = [self.itemOriginXArray[index - 1] floatValue];
        //改变X
        CGFloat originDistance = nextOriginX - currentOriginX;
        CGFloat distance = scrollView.contentOffset.x - _lastContentOffsetX;
        [self.indicateView setMj_x:self.indicateView.mj_x - originDistance/scrollView.mj_w *distance];
        //改变宽度
        CGFloat widthDistance = nextWitdth - currentWidth;
        [self.indicateView setMj_w:self.indicateView.mj_w - distance/scrollView.mj_w * widthDistance];
         _lastContentOffsetX = scrollView.contentOffset.x;
        //改变颜色
        ZXCategoryItemView *view = [self getItemViewAtIndex:index];
        view.contentLabel.textColor = [self changeRGB:view.contentLabel.textColor changeValue:distance/scrollView.mj_w];
        
        ZXCategoryItemView * nextView = [self getItemViewAtIndex:index-1];
        nextView.contentLabel.textColor = [self changeRGB:nextView.contentLabel.textColor changeValue:-distance/scrollView.mj_w];

    }
    if ([direction isEqualToString:@"向左"]) {
        NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
        if (index >= self.itemArray.count || index < 0) {
            return;
        }
        CGFloat currentWidth = [self.itemWidthArray[index] floatValue];
        CGFloat currentOriginX = [self.itemOriginXArray[index] floatValue];

        if (index + 1 == self.itemArray.count) {
            return;
        }
        nextWitdth = [self.itemWidthArray[index + 1] floatValue];
        nextOriginX = [self.itemOriginXArray[index + 1] floatValue];
        //改变x
        CGFloat originDistance = nextOriginX - currentOriginX;
        CGFloat distance = scrollView.contentOffset.x - _lastContentOffsetX;
        [self.indicateView setMj_x:self.indicateView.mj_x + originDistance/scrollView.mj_w *distance];
        //改变宽度
        CGFloat widthDistance = nextWitdth - currentWidth;
        [self.indicateView setMj_w:self.indicateView.mj_w + distance/scrollView.mj_w * widthDistance];
        _lastContentOffsetX = scrollView.contentOffset.x;
        //改变颜色
        ZXCategoryItemView *view = [self getItemViewAtIndex:index];
        view.contentLabel.textColor = [self changeRGB:view.contentLabel.textColor changeValue:-distance/scrollView.mj_w];

        ZXCategoryItemView * nextView = [self getItemViewAtIndex:index + 1];;
        nextView.contentLabel.textColor = [self changeRGB:nextView.contentLabel.textColor changeValue:distance/scrollView.mj_w];
    }
}

- (ZXCategoryItemView *)getItemViewAtIndex:(NSInteger )index{
    ZXCategoryItemView *view = (ZXCategoryItemView *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return view;
}

- (UIColor *)changeRGB:(UIColor *)color changeValue:(CGFloat)value{
    NSArray *nextViewRgbArray = [self getRGBWithColor:color];
    color = [UIColor colorWithRed:[nextViewRgbArray[0] floatValue] + value green:[nextViewRgbArray[1] floatValue] blue:[nextViewRgbArray[2] floatValue] alpha:[nextViewRgbArray[3] floatValue]];
    return color;
}

#pragma mark - getters and setters

- (UIView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake([self.itemOriginXArray[_originIndex] floatValue], 40 - 2, [self.itemWidthArray [_originIndex] floatValue], 2)];
        _indicateView.backgroundColor = [UIColor redColor];
    }
    return _indicateView;
}


- (void)setItemArray:(NSArray *)itemArray{
    _itemArray = itemArray;
    [self initItemWidthArray];
    [self.mainCollectionView addSubview:self.indicateView];
    [self.mainCollectionView reloadData];
    [self adjustContentOffsetToIndex:self.originIndex completeHanle:nil animation:NO];
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:self.originIndex];
    }
}

- (void)initItemWidthArray{
    CGFloat originX = itemInteval;
    for (int i = 0; i< self.itemArray.count; i++) {
        NSString *item = self.itemArray[i];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGSize textSize = [item sizeWithAttributes:attributes];
        CGFloat currentOriginX = originX;
        [self.itemOriginXArray addObject:@(currentOriginX)];
        [self.itemWidthArray addObject:@(textSize.width)];
        originX = originX + textSize.width + itemInteval;
    }
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.bounces = NO;
        [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCategoryItemView class]) bundle:nil] forCellWithReuseIdentifier:@"ZXCategoryItemViewIdentifier"];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = itemInteval;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, itemInteval, 0, itemInteval);
    }
    return _flowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCategoryItemViewIdentifier" forIndexPath:indexPath];
    cell.contentLabel.text = self.itemArray[indexPath.row];
    cell.index = indexPath.row;
    if (indexPath.row == self.currentIndex) {
        cell.contentLabel.textColor = [UIColor redColor];
    }
    else{
        cell.contentLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize itemSize = CGSizeMake([self.itemWidthArray[indexPath.row]floatValue], self.frame.size.height);
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isMoniteScroll = NO;
    _lastContentOffsetX = self.moniterScrollView.mj_w * indexPath.row;
    NSNotification *notification = [[NSNotification alloc]initWithName:RESETCOLORNOTIFICATION object:@"color" userInfo:@{@"color":[UIColor blackColor],@"index":@(indexPath.row)}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentLabel.textColor = [UIColor redColor];
    _currentIndex = indexPath.row;
    [self adjustContentOffsetToIndex:indexPath.row completeHanle:^{
    } animation:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:indexPath.row];
    }
}


- (void)adjustContentOffsetToIndex:(NSInteger)index completeHanle:(void(^)())completeHandle animation:(BOOL)animation{
    CGFloat maxContentOffsetX = [[self.itemOriginXArray lastObject]floatValue] + [[self.itemWidthArray lastObject] floatValue] + 30 - self.frame.size.width;
    CGFloat indexCenterOffsetX = [self.itemOriginXArray[index] floatValue] + [self.itemWidthArray[index] floatValue]*0.5 - self.frame.size.width * 0.5;
    if (indexCenterOffsetX > maxContentOffsetX) {
        [self scrollToPoint:CGPointMake(maxContentOffsetX, 0) CompleteHandle:completeHandle animation:animation];
    }
    else if (indexCenterOffsetX <= 0)
    {
        [self scrollToPoint:CGPointMake(0, 0) CompleteHandle:completeHandle animation:animation];
    }
    else{
        [self scrollToPoint:CGPointMake(indexCenterOffsetX, 0) CompleteHandle:completeHandle animation:animation];
    }
    
}

- (void)scrollToPoint:(CGPoint)point CompleteHandle:(void(^)())completeHandle animation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.mainCollectionView setContentOffset:point];
            [self.indicateView setMj_w:[self.itemWidthArray[self.currentIndex] floatValue]];
            [self.indicateView setMj_x:[self.itemOriginXArray[self.currentIndex]floatValue]];
            } completion:^(BOOL finished) {
            if (completeHandle) {
                completeHandle();
            }
        }];

    }else{
        [self.mainCollectionView setContentOffset:point];
        if (completeHandle) {
            completeHandle();
        }
    }
}

- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

@end

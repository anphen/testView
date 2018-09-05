//
//  ZXCategoryView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXCategoryView.h"
#import "ZXCategoryItemView.h"

static NSString *const itemViewIdentifier = @"ZXCategoryItemViewIdentifier";
NSString *const RESETCOLORNOTIFICATION = @"RESETCOLORNOTIFICATION";

@interface ZXCategoryView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIView *indicateView;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemOffsetX_max;
@property (nonatomic, copy) didSelectItemBlock selectBlock;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZXCategoryView

- (instancetype)initWithFrame:(CGRect)frame didSelectItemBlock:(didSelectItemBlock)selectBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectBlock = selectBlock;
        [self initialization];
        [self setUpUI];
    }
    return self;
}

- (void)initialization{
    _lineSpace = 1.0;
    _itemSizeScale = 2.5;
    _upDownInset = 1;
    _itemNormalColor = [UIColor blackColor];
    _itemSelectColor = [UIColor orangeColor];
    _originIndex = 0;
    _indicateViewColor = [UIColor orangeColor];
}

- (void)setUpUI
{
    [self addSubview:self.mainCollectionView];
    [self.mainCollectionView addSubview:self.indicateView];
     _itemOffsetX_max = _itemSize.width + 2 +(self.itemArray.count - 1)* (_lineSpace +_itemSize.width ) - self.mainCollectionView.frame.size.width;
}

- (void)reloadView
{
    [self.indicateView removeFromSuperview];
    self.indicateView = nil;
    [self.mainCollectionView removeFromSuperview];
    self.mainCollectionView = nil;
    self.flowLayout = nil;
    [self setUpUI];
}

#pragma mark - getters and setters
- (UIView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake(1 + _originIndex * (_itemSize.width + _lineSpace) , _itemSize.height, _itemSize.width, 2)];
        _indicateView.backgroundColor = _indicateViewColor;
    }
    return _indicateView;
}


- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _centerX = _mainCollectionView.center.x;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor lightGrayColor];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"ZXCategoryItemView" bundle:nil] forCellWithReuseIdentifier:itemViewIdentifier];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _itemSize = CGSizeMake((self.frame.size.height - 2 * _upDownInset) * _itemSizeScale, self.frame.size.height - 2 * _upDownInset);
        _flowLayout.itemSize = _itemSize;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = self.lineSpace;
        _flowLayout.sectionInset = UIEdgeInsetsMake(1, _upDownInset, 1, _upDownInset);
    }
    return _flowLayout;
}

- (void)setItemArray:(NSArray<NSString *> *)itemArray
{
    _itemArray = itemArray;
   
    [self reloadView];
    [self scrollToIndex:_originIndex animation:NO];
    if (self.selectBlock) {
        self.selectBlock(_originIndex, self);
    }
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
    
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[collectionView dequeueReusableCellWithReuseIdentifier:itemViewIdentifier forIndexPath:indexPath];
    cell.itemContent = self.itemArray[indexPath.row];
    cell.contentLabel.textColor = _itemNormalColor;
    if (indexPath.row == _currentIndex) {
        cell.contentLabel.textColor = _itemSelectColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollToIndex:indexPath.row animation:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath.row, self);
    }
}

- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation
{
    NSNotification *notification = [[NSNotification alloc]initWithName:RESETCOLORNOTIFICATION object:@"color" userInfo:@{@"color":_itemNormalColor}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    CGFloat itemCenter_x = self.itemSize.width * (index + 0.5) + 1 + index * self.lineSpace;
    CGFloat itemOffset_x = itemCenter_x -  self.centerX;
    if (itemOffset_x <= 0) {
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0) animated:animation];
    }
    else if ( itemOffset_x >= _itemOffsetX_max )
    {
        [self.mainCollectionView setContentOffset:CGPointMake(_itemOffsetX_max, 0) animated:animation];
    }
    else{
        [self.mainCollectionView setContentOffset:CGPointMake(itemOffset_x, 0) animated:animation];
    }
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.contentLabel.textColor = _itemSelectColor;
    if (animation) {
        CGFloat cellCenter_x;
        if (cell) {
            cellCenter_x = cell.center.x;
        }
        else
        {
            cellCenter_x = 1 + index * (_itemSize.width + _lineSpace) + 0.5 * _itemSize.width;
        }
        [UIView animateWithDuration:0.2 animations:^{
            _indicateView.center = CGPointMake(cellCenter_x,  _itemSize.height + 1);
        }];
    }
    _currentIndex = index;
}
@end

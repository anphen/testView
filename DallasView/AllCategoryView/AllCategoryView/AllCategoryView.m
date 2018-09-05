//
//  AllCategoryView.m
//  SuningEBuy
//
//  Created by zhaoxu on 2017/4/11.
//  Copyright © 2017年 苏宁易购. All rights reserved.
//

#import "AllCategoryView.h"
#import "UIView+Additions.h"
//#import "DefineConstant.h"
#import "AllCategoryCell.h"

NSString *cellIdentifier = @"AllCategoryCellIdetifier";
@interface AllCategoryView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation AllCategoryView

- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemArray = itemArray;
        [self addSubview:self.mainCollectionView];
    }
    return self;
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight = lineHeight;
    _flowLayout.itemSize = CGSizeMake(self.width / 3.0, lineHeight);
    [self.mainCollectionView reloadData];
}

#pragma mark - getters and setters
- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.width / 3.0, self.lineHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _flowLayout = flowLayout;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
        [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AllCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
    }
    return _mainCollectionView;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecoverCellState" object:nil];
    AllCategoryCell *cell = (AllCategoryCell *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    [cell changeState];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.text = self.itemArray[indexPath.row];
    if (self.selectIndex == 0 && indexPath.row == 0) {
        [cell changeState];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(didSelectedItemAtIndex:)]) {
        [self.delegate didSelectedItemAtIndex:indexPath.row];
    }
}

@end

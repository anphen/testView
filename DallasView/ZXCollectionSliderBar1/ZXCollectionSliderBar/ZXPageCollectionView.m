//
//  ZXPageCollectionView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXPageCollectionView.h"
#import <objc/runtime.h>

static char UIViewReuseIdentifier;

@implementation UIView(_reuseIdentifier)

- (void) setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, &UIViewReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) reuseIdentifier {
    return objc_getAssociatedObject(self, &UIViewReuseIdentifier);
}

@end

@interface ZXPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *cellMainView;

@end

@implementation ZXPageCollectionViewCell

- (void)setCellMainView:(UIView *)cellMainView
{
    if (!_cellMainView) {
        _cellMainView = cellMainView;
        [self.contentView addSubview:_cellMainView];
    }
    else if (cellMainView != _cellMainView){
        [_cellMainView removeFromSuperview];
        _cellMainView = cellMainView;
        [self.contentView addSubview:_cellMainView];
    }
}

@end

static NSString *const identifier = @"mainCollectionViewIdentifier";

@interface ZXPageCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
{
    float lastContentOffset;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, copy) NSString *currentIdentifier;
@property (nonatomic, strong) NSMutableArray *reUseViewArray;
@property (nonatomic, assign) NSInteger totolCount;

@end

@implementation ZXPageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _reUseViewArray = [[NSMutableArray alloc]init];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.mainCollectionView];
    [self.mainCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)reloadView{
    [self.reUseViewArray removeAllObjects];
    [self.mainCollectionView reloadData];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
       NSInteger index = self.mainCollectionView.contentOffset.x / self.frame.size.width;
        if (index < 0) {
            return;
        }
        self.currentIndex = index;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        ZXPageCollectionViewCell *cell = (ZXPageCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
        self.currentView = cell.cellMainView;
    }
}

#pragma mark - getters and setters
- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.bounces = NO;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerClass:[ZXPageCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return  _totolCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPageCollectionViewCell *cell = (ZXPageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIView *view;
    if ([self.dataSource respondsToSelector:@selector(ZXPageCollectionView:viewForItemAtIndex:)]) {
       view = [self.dataSource ZXPageCollectionView:self viewForItemAtIndex:indexPath.row];
    }
    view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (view) {
        cell.cellMainView = view;
        BOOL isExist = NO;
        for (UIView *view1 in self.reUseViewArray) {
            if ([view1.reuseIdentifier isEqualToString:view.reuseIdentifier]) {
                isExist = YES;
            }
        }
        if (!isExist) {
            [self.reUseViewArray addObject:view];
        }
    }
    
    if (_noAnimationIndex && [_noAnimationIndex integerValue] == indexPath.row) {
        if ([self.delegate respondsToSelector:@selector(ZXPageViewDidEndChangeIndex:currentView:)]) {
            [self.delegate ZXPageViewDidEndChangeIndex:self currentView:cell.cellMainView];
        }
        _noAnimationIndex = nil;
    }
    return cell;
}

- (void)registerClass:(Class)viewClass forViewWithReuseIdentifier:(NSString *)identifier{

}

- (UIView *)dequeueReuseViewWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    for (UIView *view in self.reUseViewArray) {
        if ([view.reuseIdentifier isEqualToString:identifier]) {
            return view;
        }
    }
    return nil;
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation{
    if (index >= self.totolCount || index < 0) {
        return;
    }
    if (animation) {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animation];

    }
    if (!animation) {
        self.noAnimationIndex = [NSString stringWithFormat:@"%ld", index];
        [self.mainCollectionView moveItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

- (void)setDataSource:(id<ZXPageCollectionViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _totolCount = [self.dataSource numberOfItemsInZXPageCollectionView:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(ZXPageViewDidEndChangeIndex:currentView:)]) {
        [self.delegate ZXPageViewDidEndChangeIndex:self currentView:self.currentView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString *direction = @"";
    if (lastContentOffset < scrollView.contentOffset.x) {
        direction = @"向左";
    }else{
        direction = @"向右";
    }
    if ([self.delegate respondsToSelector:@selector(ZXPageViewDidScroll: direction:)]) {
        [self.delegate ZXPageViewDidScroll:scrollView direction:direction];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(ZXPageViewWillBeginDragging:)]) {
        [self.delegate ZXPageViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(ZXPageViewDidEndDecelerating:currentView:)]) {
        [self.delegate ZXPageViewDidEndDecelerating:self currentView:self.currentView];
    }
}

- (void)dealloc
{
    [self.mainCollectionView removeObserver:self forKeyPath:@"contentOffset"];
}

@end

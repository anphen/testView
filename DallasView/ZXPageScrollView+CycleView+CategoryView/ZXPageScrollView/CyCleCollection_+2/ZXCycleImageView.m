//
//  ZXCycleImageView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/28.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXCycleImageView.h"
#import "ZXCycleCollectionViewCell.h"

static NSString *const cellIdentifier = @"CycleCellIdentifier";

@interface ZXCycleImageView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZXCycleImageView

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self.mainCollectionView reloadData];
    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.currentIndex = 1;
    self.autoScrollTimeInterval = 2.0;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainCollectionView];
    }
    return self;
}

#pragma mark - getters and setters
- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.bounces = NO;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        [_mainCollectionView registerClass:NSClassFromString(@"ZXCycleCollectionViewCell") forCellWithReuseIdentifier:cellIdentifier];
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
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout.footerReferenceSize = CGSizeZero;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}
#pragma mark - getters and setters
-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self setupTimer];
    }
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.numberOfPages = self.imageArray.count;
    }
    return _pageControl;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCycleCollectionViewCell *cell = (ZXCycleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageName = [self.imageArray lastObject];
    }
    else if (indexPath.row == self.imageArray.count + 1) {
        cell.imageName = [self.imageArray firstObject];
    }
    else {
        cell.imageName = self.imageArray[indexPath.row - 1];
    }
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}
#pragma mark - method

- (void)automaticScroll
{
    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - time
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (showPageControl) {
        [self addSubview:self.pageControl];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}
#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        self.pageControl.currentPage = self.currentIndex - 1;
    }
}

#pragma mark - delloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentIndex"];
}

@end

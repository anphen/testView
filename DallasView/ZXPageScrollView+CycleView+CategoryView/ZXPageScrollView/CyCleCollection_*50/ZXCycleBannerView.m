//
//  ZXCycleBannerView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/30.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXCycleBannerView.h"
#import "ZXCycleCollectionViewCell.h"
#import <objc/runtime.h>

static NSString *const cellIdentifier = @"CycleCellIdentifier";
static NSInteger const multiple = 10;
static char UIViewReuseIdentifier;

@implementation UIView(_ZXCycleBannerReuseIdentifier)

- (void) setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, &UIViewReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) reuseIdentifier {
    return objc_getAssociatedObject(self, &UIViewReuseIdentifier);
}

@end

@interface ZXCycleBannerView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat maxContentOffsetX ;

@property (nonatomic, strong) NSMutableArray *reUseViewArray;
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation ZXCycleBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _autoScrollTimeInterval = 2.0;
        _reUseViewArray = [NSMutableArray array];
        [self addSubview:self.mainCollectionView];
    }
    return self;
}

- (void)setDataSource:(id<ZXCycleBannerViewDataSource>)dataSource{
    _dataSource = dataSource;
    if ([dataSource respondsToSelector:@selector(numberOfItemsZXCycleBannerView:)]) {
        self.itemCount = [self.dataSource numberOfItemsZXCycleBannerView:self];
        self.maxContentOffsetX = self.mainCollectionView.frame.size.width * (self.itemCount * multiple - 1);
    }
    [self.mainCollectionView reloadData];
    [self reLocationMiddleFirstIndex];
}

- (void)setDelegate:(id<ZXCycleBannerViewDelegate>)delegate{
    
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

- (void)reLocationMiddleFirstIndex{
    [self.mainCollectionView setContentOffset:CGPointMake((self.itemCount * 0.5 * multiple) * self.mainCollectionView.frame.size.width, 0)];
}

- (void)reLocationMiddleLastIndex{
    [self.mainCollectionView setContentOffset:CGPointMake((self.itemCount * 0.5 * multiple + 3) * self.mainCollectionView.frame.size.width, 0)];
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
        _pageControl.numberOfPages = self.itemCount;
    }
    return _pageControl;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (self.showPageControl) {
        self.pageControl.currentPage = self.currentIndex;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (showPageControl) {
        [self addSubview:self.pageControl];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount * multiple;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCycleCollectionViewCell *cell = (ZXCycleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(bannerView:viewForItemAtIndex:)]) {
        NSInteger viewIndex = indexPath.row % self.itemCount;
        UIView * currentView = [self.dataSource bannerView:self viewForItemAtIndex:viewIndex];
        if (currentView) {
            cell.bannerItemView = currentView;
            BOOL isExist = NO;
            for (UIView *view1 in self.reUseViewArray) {
                if ([view1.reuseIdentifier isEqualToString:currentView.reuseIdentifier]) {
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                [self.reUseViewArray addObject:currentView];
            }
        }
    }
    return cell;
}

- (void)adjustContentOffsetX{
    if (self.mainCollectionView.contentOffset.x == 0 ) {
        [self reLocationMiddleFirstIndex];
    }
    if (self.mainCollectionView.contentOffset.x == self.maxContentOffsetX) {
        [self reLocationMiddleLastIndex];
    }
    NSInteger count = self.mainCollectionView.contentOffset.x / self.mainCollectionView.frame.size.width;
    self.currentIndex = count % self.itemCount;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustContentOffsetX];
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self adjustContentOffsetX];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

#pragma mark - time
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll
{
    CGFloat currentOffsetX = self.mainCollectionView.contentOffset.x;
    [self.mainCollectionView setContentOffset:CGPointMake((currentOffsetX + self.mainCollectionView.frame.size.width), 0) animated:YES];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

@end

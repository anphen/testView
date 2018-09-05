//
//  ZXCyCleScrollView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/28.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXCyCleScrollView.h"

@interface ZXCyCleScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *perImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZXCyCleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = frame.size.width;
        _height = frame.size.height;
        [self addSubview:self.mainScrollView];
        [self configMainScrollView];
    }
    return self;
}

- (void)configMainScrollView
{
    self.perImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    [self.mainScrollView addSubview:self.perImageView];
    
    self.midImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_width, 0, _width, _height)];
    [self.mainScrollView addSubview:self.midImageView];

    self.nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2 * _width, 0, _width, _height)];
    [self.mainScrollView addSubview:self.nextImageView];
    self.mainScrollView.contentOffset = CGPointMake(_width, 0);
    _currentImageIndex = 0;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
        _mainScrollView.contentSize = CGSizeMake(3 * _width, 0);
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustImageView];
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self adjustImageView];
}

- (void)adjustImageView{
    if (self.mainScrollView.contentOffset.x == 0) {
        self.currentImageIndex = self.currentImageIndex -1;
        if (self.currentImageIndex < 0) {
            self.currentImageIndex = self.imageArray.count - 1;
        }
    }
    if (self.mainScrollView.contentOffset.x == 2 * _width) {
         self.currentImageIndex = self.currentImageIndex  + 1;
        if (self.currentImageIndex >= self.imageArray.count) {
            self.currentImageIndex = 0;
        }
    }
    if (self.currentImageIndex == 0) {
        self.midImageView.image = [UIImage imageNamed: self.imageArray[0]];
        self.perImageView.image = [UIImage imageNamed: [self.imageArray lastObject]];
        self.nextImageView.image = [UIImage imageNamed: self.imageArray [1]];
    }
    else if (self.currentImageIndex == self.imageArray.count - 1) {
        self.midImageView.image = [UIImage imageNamed: [self.imageArray lastObject]];
        self.perImageView.image = [UIImage imageNamed: self.imageArray[self.imageArray.count - 2]];
        self.nextImageView.image = [UIImage imageNamed: self.imageArray [0]];
    }
    else{
        self.midImageView.image = [UIImage imageNamed: self.imageArray[_currentImageIndex]];
        self.perImageView.image = [UIImage imageNamed: self.imageArray[_currentImageIndex - 1]];
        self.nextImageView.image = [UIImage imageNamed: self.imageArray [_currentImageIndex +1]];
    }
    
    self.mainScrollView.contentOffset = CGPointMake(_width, 0);
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    self.midImageView.image = [UIImage imageNamed:[imageArray firstObject]];
    self.perImageView.image = [UIImage imageNamed:[imageArray lastObject]];
    self.nextImageView.image = [UIImage imageNamed:imageArray[1]];
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

#pragma mark - method
- (void)automaticScroll
{
    [self.mainScrollView setContentOffset:CGPointMake(2 *  _width, 0) animated:YES];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
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

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - pageControll
- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (showPageControl) {
        [self addSubview:self.pageControl];
        [self addObserver:self forKeyPath:@"currentImageIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentImageIndex"]) {
        self.pageControl.currentPage = self.currentImageIndex;
    }
}

#pragma mark - delloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPageIndex"];
}
@end

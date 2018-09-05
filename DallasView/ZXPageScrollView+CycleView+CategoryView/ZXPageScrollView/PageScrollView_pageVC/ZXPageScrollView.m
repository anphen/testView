//
//  ZXPageScrollView.m
//  ZXPageScrollViewfimewivbomqerojb ijodfnmvkodafmvkdkk,e,dc,dc,lfc,fck,fckfkfkfkfkfkfmv
//
//  Created by zhaoxu on 2017/3/26.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ZXPageScrollView.h"

static NSInteger const originViewTag = 11010;

@interface ZXPageScrollView()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) UIPageViewController *mainPageVC;
@property (nonatomic, weak) id<ZXPageScrollViewDelegate> delegate;
@property (nonatomic, weak) id<ZXPageScrollViewDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *pageViewControllerCacheArray;
@property (nonatomic, strong) UIViewController *originVC;
@property (nonatomic, strong) UIViewController *beforVC;
@property (nonatomic, strong) UIViewController *afterVC;
@property (nonatomic, assign) BOOL isClipToBounds;
@property (nonatomic, assign) BOOL isGoForward;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UIViewController *pendingViewController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZXPageScrollView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<ZXPageScrollViewDelegate>)delegate
                   dataSource:(id<ZXPageScrollViewDataSource>)dataSource;
{
    self = [self initWithFrame:frame delegate:delegate dataSource:dataSource originIndex:0];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<ZXPageScrollViewDelegate>)delegate
                   dataSource:(id<ZXPageScrollViewDataSource>)dataSource
                  originIndex:(NSInteger)index;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPageIndex = index;
        self.dataSource = dataSource;
        self.delegate = delegate;
        [self initialization];
        [self setUpCache];
        [self setUpUI];
    }
    return self;
}

#pragma mark - method
- (void)initialization{
    self.isClipToBounds = NO;
    self.autoScrollTimeInterval = 2.0;
}

- (void)setUpCache{
    self.pageViewControllerCacheArray = [[NSMutableArray alloc]init];
    if ([self.dataSource respondsToSelector:@selector(numberOfItemInZXPageScrollView:)]) {
        NSInteger count = [self.dataSource numberOfItemInZXPageScrollView:self];
        self.totalPage = count;
        for (int i = 0; i < count; i++) {
            [self.pageViewControllerCacheArray addObject:@""];
        }
    }
}

-(void)setUpUI{
    self.mainPageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.mainPageVC.delegate = self;
    self.mainPageVC.dataSource = self;
    if ([self.dataSource respondsToSelector:@selector(ZXPageScrollView:viewControllInIndex:)]) {
        self.originVC = [self.dataSource ZXPageScrollView:self viewControllInIndex:self.currentPageIndex];
        self.originVC.view.tag = originViewTag + self.currentPageIndex;
        self.currentVC = self.originVC;
        [self addCurrentVCToCache];
    }
    if ([self.dataSource respondsToSelector:@selector(ZXPageScrollView:viewInIndex:)]) {
        self.originVC = [self packageView:[self.dataSource ZXPageScrollView:self viewInIndex:self.currentPageIndex]];
        self.originVC.view.tag = originViewTag + self.currentPageIndex;
        self.currentVC = self.originVC;
        [self addCurrentVCToCache];
    }
    if (!self.originVC) {
        return;
    }
    [self.mainPageVC setViewControllers:@[self.originVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.mainPageVC.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.mainPageVC.view];
}

- (UIViewController *)packageView:(UIView *)view
{
    UIViewController *VC = [[UIViewController alloc]init];
    [VC setValue:view forKey:@"view"];
    return VC;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

#pragma mark - handle scroll
- (void)automaticScroll{
    NSInteger index = self.currentPageIndex + 1;
    if (index == self.totalPage) {
        index = 0;
    }
    [self scrollPageViewToIndex:index animation:YES];
}

- (BOOL)scrollPageViewToIndex:(NSInteger)index{
    return [self scrollPageViewToIndex:index animation:YES];
}

- (BOOL)scrollPageViewToIndex:(NSInteger)index animation:(BOOL)animation
{
    self.autoScroll?[self invalidateTimer]:nil;
    UIViewController *VC = [self getViewControllerAtIndex:index];
    if (!VC) {
        if ([self.delegate respondsToSelector:@selector(ZXPageScrollView:willTransitionToViewController:fromViewController:)]) {
            [self.delegate ZXPageScrollView:self willTransitionToViewController:nil fromViewController:self.currentVC];
        }
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(ZXPageScrollView:willTransitionToViewController:fromViewController:)]) {
        [self.delegate ZXPageScrollView:self willTransitionToViewController:VC fromViewController:self.currentVC];
    }
    VC.view.tag = originViewTag + index;
    __weak typeof(self)weakSelf = self;
    if (VC.view.tag > self.currentVC.view.tag || self.currentVC.view.tag - VC.view.tag == self.totalPage - 1) {
        [self.mainPageVC setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:animation completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
            weakSelf.currentVC = VC;
            [weakSelf addCurrentVCToCache];
            if ([weakSelf.delegate respondsToSelector:@selector(ZXPageScrollView:didFinishTransition:)]) {
                [weakSelf.delegate ZXPageScrollView:weakSelf didFinishTransition:YES];
            }
            [weakSelf setupTimer];
        }];
    }
    else{
        [self.mainPageVC setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionReverse animated:animation completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
            weakSelf.currentVC = VC;
            [weakSelf addCurrentVCToCache];
            if ([weakSelf.delegate respondsToSelector:@selector(ZXPageScrollView:didFinishTransition:)]) {
                [weakSelf.delegate ZXPageScrollView:weakSelf didFinishTransition:YES];
            }
            [weakSelf setupTimer];
        }];
    }
    return YES;
}

#pragma mark - cache
- (UIViewController *)safetyGetIndexVCInCache:(NSInteger)index
{
    NSInteger count = self.pageViewControllerCacheArray.count;
    if (index >= count || index < 0) {
        return nil;
    }
    if (![[self.pageViewControllerCacheArray objectAtIndex:index] isKindOfClass:[UIViewController class]]) {
        return nil;
    }
    return [self.pageViewControllerCacheArray objectAtIndex:index];
}

- (void)checkViewController:(UIViewController *)VC isNeedCacheAtIndex:(NSInteger)index{
    if (![self safetyGetIndexVCInCache:index]) {
        [self addVC:VC toCacheIndex:index];
    }
}

- (void)addCurrentVCToCache{
    [self addVC:self.currentVC toCacheIndex:self.currentPageIndex];
}

- (void)addVC:(UIViewController *)VC toCacheIndex:(NSInteger)index{
    [self.pageViewControllerCacheArray removeObjectAtIndex:index];
    [self.pageViewControllerCacheArray insertObject:VC atIndex:index];
}

- (void)resetBeforAndAfterVC{
    self.beforVC = nil;
    self.afterVC = nil;
    self.pendingViewController = nil;
}

- (UIViewController *)getViewControllerAtIndex:(NSInteger)index{
    UIViewController *VC = nil;
    if ([self.dataSource respondsToSelector:@selector(ZXPageScrollView:viewControllInIndex:)]) {
        if ([self safetyGetIndexVCInCache:index]) {
            VC = [self safetyGetIndexVCInCache:index];
        }
        else{
            VC = [self.dataSource ZXPageScrollView:self viewControllInIndex:index];
        }
    }
    if ([self.dataSource respondsToSelector:@selector(ZXPageScrollView:viewInIndex:)]) {
        if ([self safetyGetIndexVCInCache:index]) {
            VC = [self safetyGetIndexVCInCache:index];
        }
        else{
            VC = [self packageView:[self.dataSource ZXPageScrollView:self viewInIndex:index]];
        }
    }
    return VC;
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger beforIndex = self.currentPageIndex - 1;
    NSInteger beforViewTag;
    
    if (beforIndex < 0 && self.infiniteLoop) {
        beforIndex = self.totalPage - 1;
        beforViewTag = self.currentVC.view.tag + self.totalPage - 1;
    }
    else{
        beforViewTag =self.currentVC.view.tag - 1;
    }
        
    self.beforVC = [self getViewControllerAtIndex:beforIndex];
    if (self.beforVC) {
        self.beforVC.view.tag = beforViewTag;
        return self.beforVC;
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController{

    NSInteger afterIndex = self.currentPageIndex + 1;
    NSInteger afterViewTag;
    
    if (afterIndex  >= self.totalPage && self.infiniteLoop) {
        afterIndex = 0;
        afterViewTag = originViewTag;
    }
    else{
        afterViewTag = self.currentVC.view.tag + 1;
    }
    
    self.afterVC = [self getViewControllerAtIndex:afterIndex];
    if (self.afterVC) {
        self.afterVC.view.tag = afterViewTag;
        return self.afterVC;
    }
    return nil;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
    self.mainPageVC.view.userInteractionEnabled = NO;
    self.autoScroll?[self invalidateTimer]:nil;
    UIViewController *pendingVC = [pendingViewControllers lastObject];
    self.pendingViewController = pendingVC;
    if (pendingVC.view.tag > self.currentVC.view.tag){
        self.isGoForward = YES;
        if (pendingVC.view.tag - self.currentVC.view.tag == self.totalPage -1){
            self.isGoForward = NO;
        }
    }
    else{
        self.isGoForward  = NO;
        if (self.currentVC.view.tag - pendingVC.view.tag == self.totalPage -1){
            self.isGoForward = YES;
        }
    }
    if ([self.delegate respondsToSelector:@selector(ZXPageScrollView:willTransitionToViewController:fromViewController:)]){
        [self.delegate ZXPageScrollView:self willTransitionToViewController:pendingVC fromViewController:self.currentVC];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    self.autoScroll? [self setupTimer]:nil;
    if (self.beforVC) {
        [self checkViewController:self.beforVC isNeedCacheAtIndex:self.beforVC.view.tag - originViewTag];
    }
    if (self.afterVC) {
        [self checkViewController:self.afterVC isNeedCacheAtIndex:self.afterVC.view.tag - originViewTag];
    }
    if (self.isGoForward) {
        if (self.afterVC) {
            self.currentPageIndex = self.afterVC.view.tag - originViewTag;
            self.currentVC = self.afterVC;
        }
        else{
            self.currentPageIndex = self.pendingViewController.view.tag - originViewTag;
            self.currentVC = self.pendingViewController;
        }
    }
    else{
        if (self.beforVC) {
            self.currentPageIndex = self.beforVC.view.tag - originViewTag;
            self.currentVC = self.beforVC;
        }
        else{
            self.currentPageIndex = self.pendingViewController.view.tag - originViewTag;
            self.currentVC = self.pendingViewController;
        }
    }
    [self resetBeforAndAfterVC];
    if ([self.delegate respondsToSelector:@selector(ZXPageScrollView:didFinishTransition:)]) {
        [self.delegate ZXPageScrollView:self didFinishTransition:finished];
    }
    self.mainPageVC.view.userInteractionEnabled = YES;
}

#pragma mark - timer
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

#pragma mark - getters and setters
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (autoScroll) {
        [self setupTimer];
    }
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
        _pageControl.numberOfPages = self.totalPage;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.currentPage = self.currentPageIndex;
    }
    return _pageControl;
}

- (void)setPageControlTintColor:(UIColor *)pageControlTintColor
{
    _pageControlTintColor = pageControlTintColor;
    self.pageControl.pageIndicatorTintColor = pageControlTintColor;
}

- (void)setPageControlCurrentTintColor:(UIColor *)pageControlCurrentTintColor
{
    _pageControlCurrentTintColor = pageControlCurrentTintColor;
    self.pageControl.currentPageIndicatorTintColor = pageControlCurrentTintColor;
}

- (UIView *)getCurrentView
{
    return self.currentVC.view;
}

- (NSInteger)getCurrentIndex
{
    return self.currentPageIndex;
}

- (UIViewController *)getCurrentViewController
{
    return self.currentVC;
}

#pragma mark - pageControl
- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (showPageControl) {
        [self addSubview:self.pageControl];
        [self addObserver:self forKeyPath:@"currentPageIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentPageIndex"]) {
        self.pageControl.currentPage = self.currentPageIndex;
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPageIndex"];
}

@end

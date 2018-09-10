//
//  ViewController.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/26.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "ViewController.h"
#import "ZXPageScrollView.h"
#import "ChildViewController.h"
#import "ZXCycleImageView.h"
#import "ZXCyCleScrollView.h"
#import "ZXCategoryView.h"
#import "ZXPageCollectionView.h"
#import "childVIew.h"
#import "ZXCycleBannerView.h"
//#define DZXPageScrollView
//#define DZXCycleImageView
//#define DZXCyCleScrollView
//#define DZXCategoryView
//#define DZXPageCollectionView
#define DZXCycleBannerView
#define kRandomColor  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ViewController ()<ZXPageScrollViewDelegate, ZXPageScrollViewDataSource, ZXPageCollectionViewDelegate, ZXPageCollectionViewDataSource, ZXCycleBannerViewDelegate, ZXCycleBannerViewDataSource>

@property (nonatomic, strong) ZXPageScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *swithButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ZXCategoryView *categoryView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) ZXPageCollectionView *pageCollectionView;

@end

@implementation ViewController
- (IBAction)testButtonAction:(id)sender {
//    [_categoryView scrollToIndex:arc4random_uniform(10) animation:YES];
    [self.pageCollectionView changeToIndex:arc4random()%10 animation:YES];
}
- (IBAction)swithButtonAction:(id)sender {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   // [self.pageScrollView scrollPageViewToIndex:arc4random_uniform(7)];
    self.automaticallyAdjustsScrollViewInsets = NO;//
#ifdef DZXPageScrollView
    [self.contentView addSubview: self.pageScrollView];
#endif
    
#ifdef DZXCycleImageView
    self.automaticallyAdjustsScrollViewInsets = NO;//
    self.view.backgroundColor = [UIColor lightGrayColor];
    ZXCycleImageView *cyCleScrollView = [[ZXCycleImageView alloc]initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.width * 110 /169.0)];
    [self.contentView addSubview:cyCleScrollView];
    cyCleScrollView.imageArray = @[@"h1", @"h2", @"h3", @"h4"];
    cyCleScrollView.autoScrollTimeInterval = 2.0;
    cyCleScrollView.autoScroll = NO;
    cyCleScrollView.showPageControl = YES;

#endif
    
#ifdef DZXCyCleScrollView
    ZXCyCleScrollView *cyCleScrollView1 = [[ZXCyCleScrollView alloc]initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.width * 110 /169.0)];
    [self.contentView addSubview:cyCleScrollView1];
    cyCleScrollView1.imageArray = @[@"h1", @"h2", @"h3", @"h4"];
    cyCleScrollView1.autoScrollTimeInterval = 2.0;
    cyCleScrollView1.autoScroll = NO;
    cyCleScrollView1.showPageControl = YES;
#endif
    
#ifdef DZXCycleBannerView
    ZXCycleBannerView *bannerView = [[ZXCycleBannerView alloc]initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.width * 110 /169.0)];
    bannerView.delegate = self;
    bannerView.dataSource = self;
    [self.contentView addSubview:bannerView];
    bannerView.autoScrollTimeInterval = 2.0;
    bannerView.autoScroll = YES;
    bannerView.showPageControl = YES;

#endif
    
#ifdef DZXCategoryView
    ZXCategoryView *categoryView = [[ZXCategoryView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40) didSelectItemBlock:^(NSInteger index, ZXCategoryView *categoryView) {
        NSLog(@"===%li===", (long)index);
    }];
//    categoryView.originIndex = 2;
    CGFloat scale = (self.view.frame.size.width - 6)/5.0/38;
    categoryView.itemSizeScale = scale;
    categoryView.itemArray = @[@"item0", @"item1", @"item2", @"item3", @"item4",@"item5", @"item6", @"item7", @"item8", @"item9"];
    
    
    [self.contentView addSubview:categoryView];
#endif
    
#ifdef DZXPageCollectionView
    ZXPageCollectionView *PCV = [[ZXPageCollectionView  alloc]initWithFrame:CGRectMake(50, 50, self.view.frame.size.width - 100, self.view.frame.size.height - 100)];
    PCV.delegate = self;
    PCV.dataSource = self;
    PCV.backgroundColor = [UIColor grayColor];
    [PCV registerClass:[childVIew class] forViewWithReuseIdentifier:@"childView"];
    _pageCollectionView  = PCV;
    [self.contentView addSubview:PCV];
    [PCV changeToIndex:4 animation:NO];
    
#endif
}


- (NSInteger)numberOfItemsZXCycleBannerView:(ZXCycleBannerView *)bannerView{
    return 5;
}

- (UIView *)bannerView:(ZXCycleBannerView *)bannerView
    viewForItemAtIndex:(NSInteger)index{
    NSString *reuseId = [NSString stringWithFormat:@"zxbannerviewIdentifier%li", index];
    UIView *view = [bannerView dequeueReuseViewWithReuseIdentifier:reuseId forIndex:index];
    if (!view) {
        view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
        view.backgroundColor = kRandomColor;
        view.reuseIdentifier = reuseId;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        textLabel.text = [NSString stringWithFormat:@"%li", index];
        [view addSubview:textLabel];
    }
    return view;
}

- (NSInteger)numberOfItemsInZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView{
    return 10;
}

- (UIView *)ZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView
              viewForItemAtIndex:(NSInteger)index
{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"childView%ld", (long)index];
    childVIew *childView1 = (childVIew *)[ZXPageCollectionView dequeueReuseViewWithReuseIdentifier:reuseIdentifier forIndex:index];
    if (!childView1) {
        childView1 = [[childVIew alloc]initWithFrame:CGRectMake(0, 0, ZXPageCollectionView.frame.size.width, ZXPageCollectionView.frame.size.height)];
        childView1.reuseIdentifier = reuseIdentifier;
        childView1.label.text = [NSString stringWithFormat:@"%ld", index];
    }
    return childView1;
}

- (void)ZXPageView:(ZXPageCollectionView *)pageView currentView:(UIView *)view
{
    childVIew *currentChildView = (childVIew *)view;
    if (!currentChildView.dataArray) {
        
    }
}

- (void)ZXPageViewDidEndDecelerating:(ZXPageCollectionView *)pageView currentView:(UIView *)view
{
    childVIew *cv = (childVIew *)view;
    if (cv.dataArray.count == 0) {
        [cv fetchData];
    }
}

- (void)ZXPageViewDidEndChangeIndex:(ZXPageCollectionView *)pageView currentView:(UIView *)view
{
    childVIew *cv = (childVIew *)view;
    if (cv.dataArray.count == 0) {
        [cv fetchData];
    }
}

- (void)ZXPageView:(ZXPageCollectionView *)pageView currentIndex:(NSInteger)index{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"===== %s ===== %li ===", __func__, self.index);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (ZXPageScrollView *)pageScrollView
{
    if (!_pageScrollView) {
        _pageScrollView = [[ZXPageScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 200) delegate:self dataSource:self originIndex:0];
        _pageScrollView.infiniteLoop = YES;
        _pageScrollView.autoScroll = YES;
        _pageScrollView.showPageControl = YES;
        _pageScrollView.pageControlTintColor = [UIColor yellowColor];
        _pageScrollView.pageControlCurrentTintColor = [UIColor redColor];
    }
    return _pageScrollView;
}


- (NSInteger)numberOfItemInZXPageScrollView:(ZXPageScrollView *)pageScrollView{
    return 7;
}

/*
- (UIViewController *)ZXPageScrollView:(ZXPageScrollView *)pageScrollView viewControllInIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 1:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 2:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 3:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 4:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 5:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
        case 6:
        {
            ChildViewController *childVC = [[ChildViewController alloc]initWithIndex:index];
            return childVC;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
*/


 - (UIView *)ZXPageScrollView:(ZXPageScrollView *)pageScrollView viewInIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    label.text = [NSString stringWithFormat:@"%ld", (long)index];
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (void)ZXPageScrollView:(ZXPageScrollView *)pageScrollView didFinishTransition:(BOOL)finished
{
//    NSLog(@"===== %s ===== %li ===", __func__, pageScrollView.currentPageIndex);
}

- (void)ZXPageScrollView:(ZXPageScrollView *)pageScrollView willTransitionToViewController:(UIViewController *)nextViewController fromViewController:(UIViewController *)currentViewController
{
//    NSLog(@"===== %s ===== %li ===", __func__, pageScrollView.currentPageIndex);
}

@end

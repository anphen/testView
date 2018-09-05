//
//  ViewController.m
//  ZXCollectionSliderBar
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "ZXCategorySliderBar.h"
#import "ZXPageCollectionView.h"
#import "childVIew.h"

@interface ViewController ()<ZXCategorySliderBarDelegate, ZXPageCollectionViewDelegate, ZXPageCollectionViewDataSource>
@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) ZXPageCollectionView *pageVC;
@property (nonatomic, strong) ZXCategorySliderBar *sliderBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    self.itemArray =@[@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品",@"家电"];
    [self.view addSubview:self.sliderBar];

    [self.view addSubview:self.pageVC];
    [self.pageVC moveToIndex:3 animation:NO];
    
    self.sliderBar.moniterScrollView = self.pageVC.mainCollectionView;
}

- (ZXCategorySliderBar *)sliderBar
{
    if (!_sliderBar) {
        _sliderBar = [[ZXCategorySliderBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
        _sliderBar.delegate = self;
        _sliderBar.originIndex = 3;
        _sliderBar.itemArray = self.itemArray;
    }
    return _sliderBar;
}


- (ZXPageCollectionView *)pageVC
{
    if (!_pageVC) {
        _pageVC = [[ZXPageCollectionView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
    }
    return _pageVC;
}

- (NSInteger)numberOfItemsInZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView{
    return self.itemArray.count;
}

- (void)ZXPageViewDidScroll:(UIScrollView *)scrollView direction:(NSString *)direction{
    [self.sliderBar adjustIndicateViewX:scrollView direction:direction];
}

- (UIView *)ZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView
              viewForItemAtIndex:(NSInteger)index{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"childView%ld", (long)index];
    childVIew *childView1 = (childVIew *)[ZXPageCollectionView dequeueReuseViewWithReuseIdentifier:reuseIdentifier forIndex:index];
    if (!childView1) {
        childView1 = [[childVIew alloc]initWithFrame:CGRectMake(0, 0, ZXPageCollectionView.frame.size.width, ZXPageCollectionView.frame.size.height)];
        childView1.reuseIdentifier = reuseIdentifier;
        childView1.index = index;
    }
    return childView1;
}

- (void)ZXPageViewDidEndDecelerating:(ZXPageCollectionView *)pageView currentView:(UIView *)view{
    NSLog(@"=====%s=====", __func__);
    childVIew *cv = (childVIew *)view;
    if (cv.dataArray.count == 0) {
        [cv fetchData];
    }
    [self.sliderBar setSelectIndex:pageView.currentIndex];
}

- (void)ZXPageViewDidEndChangeIndex:(ZXPageCollectionView *)pageView currentView:(UIView *)view{
    NSLog(@"=====%s=====", __func__);
    childVIew *cv = (childVIew *)view;
    if (cv.dataArray.count == 0) {
        [cv fetchData];
    }
}
- (void)ZXPageViewWillBeginDragging:(ZXPageCollectionView *)pageView
{
    self.sliderBar.isMoniteScroll = YES;
}

- (void)didSelectedIndex:(NSInteger)index{
    [self.pageVC moveToIndex:index animation:NO];
}

@end

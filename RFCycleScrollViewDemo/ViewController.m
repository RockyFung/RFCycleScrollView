//
//  ViewController.m
//  RFCycleScrollViewDemo
//
//  Created by rocky on 16/7/21.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "ViewController.h"
#import "RFCycleScrollView/RFCycleScrollView.h"
@interface ViewController ()<RFCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 网络图片
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    
    RFCycleScrollView *cycleView = [RFCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 180) delegate:self placeholderImage:nil];
    cycleView.autoScrollTimeInterval = 3; // 滚动间隔
    cycleView.currentPageDotColor = [UIColor redColor];
    cycleView.pageDotColor = [UIColor whiteColor];
    cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleView.pageControlDotSize = CGSizeMake(20, 20);
    cycleView.imageURLStringsGroup = imagesURLStrings; // 网络图片
//    cycleView.localizationImageNamesGroup = @[@"1",@"2",@"3"]; // 本地图片
    [self.view addSubview:cycleView];
}

- (void)cycleScrollView:(RFCycleScrollView *)cycleScrollView didSelectItemAtIndext:(NSInteger)index{
    NSLog(@"------- 点击了第 %ld 张图片",index);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




















@end

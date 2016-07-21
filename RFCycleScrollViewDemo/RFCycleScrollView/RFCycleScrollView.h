//
//  RFCycleScrollView.h
//  RFCycleScrollViewDemo
//
//  Created by rocky on 16/7/21.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFCycleScrollView;

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;


@protocol RFCycleScrollViewDelegate <NSObject>

/**
 *  点击图片回调位置
 */
- (void)cycleScrollView:(RFCycleScrollView *)cycleScrollView didSelectItemAtIndext:(NSInteger)index;
@end

@interface RFCycleScrollView : UIView
/** 初始轮播图 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<RFCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;


@property (nonatomic, weak) id<RFCycleScrollViewDelegate> delegate;


#pragma - 图片控制
/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 自动滚动间隔时间,默认3s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;


#pragma - 小圆点控制
/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** 分页控件位置 */
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;







@end

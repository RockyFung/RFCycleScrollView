//
//  RFCycleScrollView.h
//  RFCycleScrollViewDemo
//
//  Created by rocky on 16/7/21.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFCycleScrollView;



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

@end

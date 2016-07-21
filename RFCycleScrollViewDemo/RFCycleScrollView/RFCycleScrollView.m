//
//  RFCycleScrollView.m
//  RFCycleScrollViewDemo
//
//  Created by rocky on 16/7/21.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "RFCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIView+RFAdd.h"
#import "RFCollectionViewCell.h"


#define kCycleScrollViewInitialPageControlDotSize CGSizeMake(10, 10)

NSString * const ID = @"cycleCell";

@interface RFCycleScrollView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
@end

@implementation RFCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}


- (void)initialization{
    _infiniteLoop = YES;
    _autoScrollTimeInterval = 3.0;
    _autoScroll = YES;
    _showPageControl = YES;
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<RFCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    RFCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    return cycleScrollView;
}


#pragma - pageControl设置
- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor{
    _currentPageDotColor = currentPageDotColor;

        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;

}

- (void)setPageDotColor:(UIColor *)pageDotColor{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setupPageControl{
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    if (self.imagePathsGroup.count == 0 ) return;
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) return;
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = self.imagePathsGroup.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOnPageControl;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}



#pragma - 图片设置
- (void)setPlaceholderImage:(UIImage *)placeholderImage{
    _placeholderImage = placeholderImage;
    if (!self.backgroundImageView) {
        UIImageView *bg = [UIImageView new];
        bg.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bg belowSubview:self.mainView];
        self.backgroundImageView = bg;
    }
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup{
    [self invalidateTimer];
    _imagePathsGroup = imagePathsGroup;
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 200 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:YES];
    }else{
        self.mainView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup{
    _imageURLStringsGroup = imageURLStringsGroup;
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        }else if ([obj isKindOfClass:[NSURL class]]){
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

// 获取当前页
- (int)currentIndex
{
    if (_mainView.width == 0 || _mainView.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }
    
    return MAX(0, index);
}

// 滚动到指定页数
- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsGroup.count;
}

- (void)setupMainView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    [mainView registerClass:[RFCollectionViewCell class] forCellWithReuseIdentifier:ID];
    _mainView = mainView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 && _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;

        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);

    
    CGFloat x = (self.width - size.width) * 0.5;
    if (self.pageControlAliment == SDCycleScrollViewPageContolAlimentRight) {
        x = self.mainView.width - size.width - 10;
    }
    
    CGFloat y = self.mainView.height - size.height - 10;
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        }else{
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    }else if ([imagePath isKindOfClass:[UIImage class]]){
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndext:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndext:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.imagePathsGroup.count) {
        return;
    }
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}







































@end

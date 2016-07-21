//
//  RFCollectionViewCell.m
//  RFCycleScrollViewDemo
//
//  Created by rocky on 16/7/21.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "RFCollectionViewCell.h"
#import "UIView+RFAdd.h"
@implementation RFCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}


- (void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}


















































@end

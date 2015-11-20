//
//  WeiboPictureView.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/19.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboPictureView.h"
#import "UIImageView+WebCache.h"

@interface WeiboPictureView()

/**
 *  gif的View
 */
@property(nonatomic, strong) UIImageView *gifView;
@end

@implementation WeiboPictureView

/**
 *  重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加一个用于显示gif图片的view
        UIImage *gifImg = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:gifImg];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

/**
 *  重写picture的setter方法
 */
- (void)setPicture:(WeiboPicture *)picture {
    _picture = picture;
    
    //设置gif是否可见
    self.gifView.hidden = ![picture.thumbnail_pic hasSuffix:@".gif"];
    
    //加载gif图片
    [self sd_setImageWithURL:[NSURL URLWithString:picture.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

/**
 *  重写layoutSubViews方法
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}
@end












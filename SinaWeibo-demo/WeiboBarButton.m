//
//  WeiboBarButton.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-26.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define normalColor [UIColor blackColor]//默认字体颜色
#define selectedColor [UIColor orangeColor]//选中时字体颜色
#define imageRatio 0.618//图片的比例
#define textFont [UIFont systemFontOfSize:12]//字体大小

#import "WeiboBarButton.h"
#import "WeiboBadgeButton.h"

@implementation WeiboBarButton

- (void)setItem:(UITabBarItem *)item {
    _item = item;
    
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
//    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置按钮中文字和图片的位置与大小
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //字体大小
        [self.titleLabel setFont:textFont];
        //字体颜色
        [self setTitleColor:normalColor forState:UIControlStateNormal];
        [self setTitleColor:selectedColor forState:UIControlStateSelected];
        
        //设置角标
        //
    }
    
    return self;
}

//按钮内部图标的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * imageRatio;
    
    return CGRectMake(0, 0, imageW, imageH);
}

//按钮内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat textY = contentRect.size.height * imageRatio;
    CGFloat textW = contentRect.size.width;
    CGFloat textH = contentRect.size.height - textY;
    
    return CGRectMake(0, textY, textW, textH);
}

@end

//
//  WeiboTitleButton.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define imageWidth 25

#import "WeiboTitleButton.h"
#import "UIImage+WeiboResizeImage.h"
#import "WeiboAccount.h"

@implementation WeiboTitleButton

+ (instancetype)titleButton {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //标题按钮的背景图片
        [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
//        [self setBackgroundImage:[UIImage imageNamed:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        
        //标题字体颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置字体居右
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        //设置图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //取消高亮状态自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        
        
        //设置按钮的标题
        //    [titleButton setTitle:@"卡梅隆BBer" forState:UIControlStateNormal];
        //先获取用户的昵称
        NSString * userName = [WeiboAccount account].name;
        if (userName) {
            [self setTitle:userName forState:UIControlStateNormal];
        } else {
            [self setTitle:@"首页" forState:UIControlStateNormal];
        }
        
        //设置按钮的图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        
        //设置按钮的尺寸
        self.frame = CGRectMake(0, 0, 125, 40);
//            CGSize titleSize = [userName sizeWithAttributes:@{NSAttachmentAttributeName:self.titleLabel.font}];
//            self.frame = (CGRect){0, 0, titleSize};
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageY = 0;
    CGFloat imageW = imageWidth;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - imageWidth;
    CGFloat titleH = contentRect.size.height;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

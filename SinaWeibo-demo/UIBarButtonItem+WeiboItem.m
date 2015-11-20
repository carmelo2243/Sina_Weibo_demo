//
//  UIBarButtonItem+WeiboItem.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-21.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "UIBarButtonItem+WeiboItem.h"

@implementation UIBarButtonItem (WeiboItem)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)normalImage Highlighted:(UIImage *)highlightImage target:(id)target action:(SEL)action {
    
    //创建一个自定义按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置图片背景
//    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    //设置尺寸
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end

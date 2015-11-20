//
//  WeiboComposeToolBar.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/26.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboComposeToolBar.h"

@implementation WeiboComposeToolBar

/**
 *  重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置工具条的背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //添加按钮
        //相机
        [self addButtonWithIcon:[UIImage imageNamed:@"compose_camerabutton_background"] hightIcon:[UIImage imageNamed:@"compose_camerabutton_background_highlighted"] tag:WeiboComposeToolBarButtonTypeCamera];
        //相册
        [self addButtonWithIcon:[UIImage imageNamed:@"compose_toolbar_picture"] hightIcon:[UIImage imageNamed:@"compose_toolbar_picture_highlighted"] tag:WeiboComposeToolBarButtonTypePicture];
        //@
        [self addButtonWithIcon:[UIImage imageNamed:@"compose_mentionbutton_background"] hightIcon:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] tag:WeiboComposeToolBarButtonTypeMention];
        //话题
        [self addButtonWithIcon:[UIImage imageNamed:@"compose_trendbutton_background"] hightIcon:[UIImage imageNamed:@"compose_trendbutton_background_highlighted"] tag:WeiboComposeToolBarButtonTypeTrend];
        //表情
        [self addButtonWithIcon:[UIImage imageNamed:@"compose_emoticonbutton_background"] hightIcon:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] tag:WeiboComposeToolBarButtonTypeEmotion];
        
    }
    return self;
}

//创建工具条按钮的方法
- (void)addButtonWithIcon:(UIImage *)image hightIcon:(UIImage *)highImage tag:(WeiboComposeToolBarButtonType)tag {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;//绑定tag
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    //添加点击事件
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}
//监听点击事件
- (void)buttonTouchUp:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        [self.delegate composeToolBar:self didClickButton:button.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width/self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    //添加工具条上的按钮
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton * button = self.subviews[i];
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
    }
}
@end

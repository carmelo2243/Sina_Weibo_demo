//
//  WeiboTabBar.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-26.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboTabBar.h"
#import "WeiboBarButton.h"
#import "WeiboPlusButton.h"
#import "WeiboComposeController.h"

@interface WeiboTabBar()

/**
 *  存放按钮的数组
 */
@property (nonatomic, strong) NSMutableArray *tabBarButtons;

/**
 *  被选中的按钮
 */
@property (nonatomic,weak) WeiboBarButton *selectedButton;

/**
 *  中间的加号按钮
 */
@property (nonatomic,weak) WeiboPlusButton *plusButton;

@end

@implementation WeiboTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self setBackgroundColor:[UIColor whiteColor]];
        
        //添加一个加号按钮
        WeiboPlusButton * plusButton = [WeiboPlusButton weiboPlusButton];
        
        [self addSubview:plusButton];
        self.plusButton = plusButton;
        
        //为加号按钮添加点击事件
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

#pragma mark plusButtonClick按钮的点击事件
- (void)plusButtonClick {
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickedPlusButton:)]) {
        [self.delegate tabBar:self didClickedPlusButton:self.plusButton];
    }
}

/**
 *  重写属性tabBarButtons的getter方法，实现懒加载
 */
- (NSMutableArray *)tabBarButtons {
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)tabBarItem {
//    NSLog(@"-----参数tabBarItem%@",tabBarItem);
    //创建按钮
    WeiboBarButton * barButton = [[WeiboBarButton alloc] init];
    [self addSubview:barButton];//addSubview:会触发调用layoutSubviews方法
    
    //将按钮添加到数组中
    [self.tabBarButtons addObject:barButton];
    
    //设置按钮的数据
    barButton.item = tabBarItem;
    
//    NSLog(@"itemTitle:%@",tabBarItem.title);
//    NSLog(@"%@",self.tabBarButtons);
    
    //添加监听事件
    [barButton addTarget:self action:@selector(barButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    //默认选中第一个
    if (self.tabBarButtons.count == 1) {
        [self barButtonClick:barButton];
    }
}

#pragma mark barButtonClick按钮的点击事件
- (void)barButtonClick:(WeiboBarButton *)button {
    
    //调用代理方法进行跳转
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate
              tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    //设置按钮的选中状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

/**
 *  在该方法中循环设置按钮的frame
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //加号按钮的frame
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    self.plusButton.center = CGPointMake(centerX, centerY);
    
    //按钮frame的基础数据
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.tabBarButtons.count; index ++) {
        //根据index计算按钮的X坐标
        CGFloat buttonX = buttonW * index;
        if (index > 1) {
            buttonX += buttonW;
        }
        
        //从数组中取出按钮
        WeiboBarButton * barButton = self.tabBarButtons[index];
        
        //设置按钮的frame
        barButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        NSLog(@"%f",buttonX);
        
        //绑定按钮的tag，在各个控制器跳转时会用到
        barButton.tag = index;
    }
}

@end
















//
//  WeiboTabBar.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-26.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboTabBar;
@class WeiboPlusButton;

@protocol WeiboTabBarDelegate <NSObject>

@optional
/**
 *  选中TabBar中的Button时调用此方法
 *
 *  @param tabBar 当前TabBar
 *  @param from   从from这个Button转跳到to这个Button
 *  @param to     从from这个Button转跳到to这个Button
 */
- (void)tabBar:(WeiboTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

/**
 *  点击中间的加号按钮时调用此方法
 *
 *  @param tabBar     当前TabBar
 *  @param plusButton 加号按钮
 */
- (void)tabBar:(WeiboTabBar *)tabBar didClickedPlusButton:(WeiboPlusButton *)plusButton;
@end

@interface WeiboTabBar : UIView

/**
 *  此方法用于添加TabBarButton
 *
 *  @param tabBarItem <#tabBarItem description#>
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)tabBarItem;

@property (nonatomic,weak) id<WeiboTabBarDelegate> delegate;
@end

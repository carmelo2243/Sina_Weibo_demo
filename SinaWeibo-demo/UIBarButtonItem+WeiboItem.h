//
//  UIBarButtonItem+WeiboItem.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-21.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WeiboItem)

/**
 *  创建一个带有图片的item，返回值为UIBarButtonItem。
 *
 *  @param NormalImage    正常状态的背景图片
 *  @param highlightImage 高亮背景图片
 *  @param target         监听事件的对象
 *  @param action         监听事件
 *
 *  @return <#return value description#>
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)NormalImage Highlighted:(UIImage *)highlightImage target:(id)target action:(SEL)action;

@end

//
//  WeiboStatusToolBar.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/4.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboStatus,WeiboStatusToolBar;

@protocol WeiboStatusToolBarDelegate <NSObject>

@optional
/**
 *  点击 转发 按钮
 */
- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didRetweetButtonClicked:(UIButton *)button;

/**
 *  点击 评论 按钮
 */
- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didCommentButtonClicked:(UIButton *)button;

/**
 *  点击 赞 按钮
 */
- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didAttitudeButtonClicked:(UIButton *)button withCallBack:(void (^)())callBack;

@end

@interface WeiboStatusToolBar : UIImageView

/**
 *  WeiboStatusToolBar中的微博模型
 */
@property (nonatomic,strong) WeiboStatus *status;

/**
 *  WeiboStatusToolBar中的代理
 */
@property (nonatomic,weak) id<WeiboStatusToolBarDelegate> delegate;

@end

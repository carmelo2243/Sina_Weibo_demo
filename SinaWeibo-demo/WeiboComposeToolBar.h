//
//  WeiboComposeToolBar.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/26.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboComposeToolBar;

typedef enum {
    WeiboComposeToolBarButtonTypeCamera,//相机
    WeiboComposeToolBarButtonTypePicture,//相册
    WeiboComposeToolBarButtonTypeMention,//@
    WeiboComposeToolBarButtonTypeTrend,//话题
    WeiboComposeToolBarButtonTypeEmotion//表情
} WeiboComposeToolBarButtonType;

@protocol WeiboComposeToolBarDelegate <NSObject>

@optional
- (void)composeToolBar:(WeiboComposeToolBar *)composeBar didClickButton:(WeiboComposeToolBarButtonType)buttonType;

@end


@interface WeiboComposeToolBar : UIView

@property (nonatomic,weak) id<WeiboComposeToolBarDelegate> delegate;

@end

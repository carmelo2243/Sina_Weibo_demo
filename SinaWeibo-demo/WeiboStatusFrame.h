//
//  WeiboStatusFrame.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-24.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

/**---------------------------------------------------------*/
/** 昵称的字体 */
#define WeiboStatusNameFont [UIFont systemFontOfSize:17]

/** 时间的字体 */
#define WeiboStatusTimeFont [UIFont systemFontOfSize:14]
/** 来源的字体 */
#define WeiboStatusSourceFont WeiboStatusTimeFont

/** 正文的字体 */
#define WeiboStatusContentFont [UIFont systemFontOfSize:17]

/** 表格的边距 */
#define WeiboStatusTableBorder 5

/** cell的边距 */
#define WeiboStatusCellBorder 10
/**---------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WeiboStatus;

@interface WeiboStatusFrame : NSObject

/**
 *  微博的数据模型
 */
@property (nonatomic,strong) WeiboStatus *status;

/** 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign, readonly) CGRect picViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign, readonly) CGRect sourceLabelF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** 被转发微博的view(父控件) */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 被转发微博作者的昵称 */
@property (nonatomic, assign, readonly) CGRect retweetNameLabelF;
/** 被转发微博的正文\内容 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;
/** 被转发微博的配图 */
@property (nonatomic, assign, readonly) CGRect retweetPicViewF;

/** 微博的工具条 */
@property (nonatomic, assign, readonly) CGRect statusToolBarF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end

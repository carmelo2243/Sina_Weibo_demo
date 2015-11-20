//
//  WeiboStatusCell.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-24.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboStatusToolBar.h"

@class WeiboStatusFrame,WeiboStatusToolBar;

@interface WeiboStatusCell : UITableViewCell

/**
 *  微博的frame模型
 */
@property (nonatomic,strong) WeiboStatusFrame *statusFrame;

/**
 *  微博工具条
 */
@property (nonatomic,weak) WeiboStatusToolBar *statusToolBar;

/**
 *  快速创建cell的方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

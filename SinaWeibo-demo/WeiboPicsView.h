//
//  WeiboPicsView.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/19.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboPicsView : UIView

/**
 *  存放图片的数组
 */
@property (nonatomic,strong) NSArray *picsArray;

/**
 *  根据图片的数量获得配图View的尺寸
 */
+ (CGSize)pictureViewSizeWithPicCount:(int)count;
@end

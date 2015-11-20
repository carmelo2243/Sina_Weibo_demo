//
//  WeiboPictureView.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/19.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboPicture.h"

@class WeiboPicture;

@interface WeiboPictureView : UIImageView

/**
 *  包含一个WeiboPicture模型
 */
@property (nonatomic,strong) WeiboPicture *picture;

@end

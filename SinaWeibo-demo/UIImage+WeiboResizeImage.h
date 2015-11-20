//
//  UIImage+WeiboResizeImage.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WeiboResizeImage)

/**
 *  添加一张伸缩的图片
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizedImageWithName:(NSString *)imageName;

@end

//
//  UIImage+WeiboResizeImage.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "UIImage+WeiboResizeImage.h"

@implementation UIImage (WeiboResizeImage)

+ (UIImage *)resizedImageWithName:(NSString *)imageName {
    UIImage * image = [UIImage imageNamed:imageName];
//    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
//    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.4, image.size.width * 0.4) resizingMode:UIImageResizingModeStretch];
}

@end

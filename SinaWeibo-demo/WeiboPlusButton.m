//
//  WeiboPlusButton.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-1.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboPlusButton.h"

@implementation WeiboPlusButton

+ (instancetype)weiboPlusButton {
    return [[WeiboPlusButton alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        //设置加号按钮背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_os7"]
                              forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted_os7"]
                              forState:UIControlStateHighlighted];
        
        //设置加号按钮的图片
        [self setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_os7"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted_os7"] forState:UIControlStateHighlighted];
        
        //设置加号按钮的frame
        self.bounds = CGRectMake(0, 0, self.currentBackgroundImage.size.width, self.currentBackgroundImage.size.height);
    }
    
    return self;
}

@end

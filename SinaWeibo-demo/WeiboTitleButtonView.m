//
//  titleButtonView.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/9/5.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboTitleButtonView.h"
#import "WeiboAccount.h"

@implementation WeiboTitleButtonView

+(instancetype)titleButtonView {
    return [[self alloc] init];
}

//重写initWithFrame方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置内容居中显示
        self.contentMode = UIViewContentModeCenter;
//        self.backgroundColor = [UIColor yellowColor];
        
        //新建两个Label用于显示“发微博”和用户的昵称
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.text = @"发微博";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        
        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.backgroundColor = [UIColor greenColor];
        nameLabel.text = [WeiboAccount account].name;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor grayColor];
        [self addSubview:nameLabel];
        
        //设置Label的frame
        CGFloat titleW = 125;
        CGFloat titleH = 20;
        
        titleLabel.frame = CGRectMake(0, 0, titleW, titleH);
        
        CGFloat nameW = titleW;
        CGFloat nameH = titleH;
        CGFloat nameY = 17;
        nameLabel.frame = CGRectMake(0, nameY, nameW, nameH);
        
        self.frame = CGRectMake(0, 0, titleW, titleH + nameH);
    }
    return self;
}
@end

/**
 *  //设置Label的frame
 //        CGFloat titleW = 125;
 //        CGFloat titleH = 20;
 CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
 titleLabel.frame = (CGRect){0, 0, titleSize};
 
 //        CGFloat nameW = titleW;
 //        CGFloat nameH = titleH;
 CGFloat nameY = titleSize.height;
 CGSize nameSize = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
 nameLabel.frame = (CGRect){0, nameY, nameSize};
 
 //判断“发微博”和昵称的宽度大小,从而计算标题按钮的尺寸
 CGFloat titleButtonViewW = 0;
 if (titleSize.width < nameSize.width | titleSize.width == nameSize.width) {
 titleButtonViewW = nameSize.width;
 } else {
 titleButtonViewW = titleSize.width;
 }
 self.frame = CGRectMake(0, 0, titleButtonViewW , titleSize.height + nameSize.height);
 */


















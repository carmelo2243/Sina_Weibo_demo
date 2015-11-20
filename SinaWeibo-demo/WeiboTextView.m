//
//  WeiboTextView.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/25.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboTextView.h"

@interface WeiboTextView()

/**
 *  微博输入框中的文字提示标签
 */
@property (nonatomic, weak)UILabel *placeholderLabel;
@end

@implementation WeiboTextView

/**
 *  重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置textView可用滚动
        self.scrollEnabled = YES;
        self.font = [UIFont systemFontOfSize:17];
        
        //1.创建一个Label用于显示提示文字
        UILabel * placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.text = @"分享新鲜事...";
        placeholderLabel.font = self.font;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        
        //2.设置Label的frame
        CGFloat labelX = 4;
        CGFloat labelY = 8;
        CGSize labelSize = [placeholderLabel.text sizeWithAttributes:@{NSFontAttributeName:placeholderLabel.font}];
        placeholderLabel.frame = (CGRect){labelX, labelY, labelSize};
        
        //3.为placeholderLabel添加通知控制其是否显示
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self.placeholderLabel];
        
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
    }
    return self;
}

/**
 *  监听通知的方法
 */
- (void)textChange {
    self.placeholderLabel.hidden = (self.text.length != 0);
}

@end


























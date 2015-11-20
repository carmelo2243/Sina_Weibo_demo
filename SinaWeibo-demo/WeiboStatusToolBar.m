//
//  WeiboStatusToolBar.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/4.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define WeiboToolBarFont [UIFont systemFontOfSize:13]//工具条字体
#define WeiboToolBarColor [UIColor grayColor]//工具条字体颜色

#import "WeiboStatusToolBar.h"
#import "UIImage+WeiboResizeImage.h"
#import "WeiboStatus.h"

typedef NS_ENUM(NSInteger, AttitudeType) {
    attitudeTypeUnlike = 0,
    attitudeTypeLike = 1
    };

@interface WeiboStatusToolBar()
/**存放按钮的数组*/
@property (nonatomic, strong) NSMutableArray *buttonArray;

/**分割线*/
@property (nonatomic, strong) NSMutableArray *dividerArray;

/**转发按钮*/
@property (nonatomic, weak) UIButton *retweetButton;

/**评论按钮*/
@property (nonatomic, weak) UIButton *commentButton;

/**点赞按钮*/
@property (nonatomic, weak) UIButton *attitudeButton;
@end

@implementation WeiboStatusToolBar

//重写getter方法实现懒加载
- (NSMutableArray *)btns {
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

//重写getter方法实现懒加载
- (NSMutableArray *)dividers {
    if (_dividerArray == nil) {
        _dividerArray = [NSMutableArray array];
    }
    return _dividerArray;
}

//重写initWithFrame方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;//可以与用户交互
        //1.设置工具条的背景图片
        self.image = [UIImage resizedImageWithName:@"timeline_card_bottom_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_bottom_background_highlight"];
        
        //2.添加按钮
        //添加转发按钮
        self.retweetButton = [self buttonWithTitle:@"转发" image:@"timeline_icon_retweet" backgroundImage:@"timeline_card_middle_background" action:@selector(retweetButtonClick)];
        
        //添加评论按钮
        self.commentButton = [self buttonWithTitle:@"评论" image:@"timeline_icon_comment" backgroundImage:@"timeline_card_middle_background" action:@selector(commentButtonClick)];
        //添加点赞按钮
        self.attitudeButton = [self buttonWithTitle:@"赞" image:@"timeline_icon_unlike" backgroundImage:@"timeline_card_middle_background" action:@selector(attitudeButtonClick)];
        //为
        self.attitudeButton.tag = attitudeTypeUnlike;
        
        //3.添加两条分割线
        [self addDividers];
        [self addDividers];
    }
    return self;
}

//创建按钮的方法
- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)image backgroundImage:(NSString *)backgroundImage action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    //设置按钮的图片
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //设置按钮的背景图片
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizedImageWithName:@"timeline_card_middle_background_highlighted"] forState:UIControlStateHighlighted];
    //设置按钮的字体及颜色
    [button setTitleColor:WeiboToolBarColor forState:UIControlStateNormal];
    button.titleLabel.font = WeiboToolBarFont;
    button.adjustsImageWhenHighlighted = NO;
    
    //给按钮添加点击事件
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    //添加按钮到数组
    [self.btns addObject:button];
    
    return button;
}

#pragma mark 工具条statusToolBar的按钮点击事件
/**
 *  点击了 转发 按钮
 */
- (void)retweetButtonClick {
//    NSLog(@"retweetButtonClick");
    if ([self.delegate respondsToSelector:@selector(statusToolBar:didRetweetButtonClicked:)]) {
        [self.delegate statusToolBar:self didRetweetButtonClicked:self.retweetButton];
    }
}

/**
 *  点击了 评论 按钮
 */
- (void)commentButtonClick {
//    NSLog(@"commentButtonClick");
    if ([self.delegate respondsToSelector:@selector(statusToolBar:didCommentButtonClicked:)]) {
        [self.delegate statusToolBar:self didCommentButtonClicked:self.commentButton];
    }
}

/**
 *  点击了 赞 按钮
 */
- (void)attitudeButtonClick {
//    NSLog(@"attitudeButtonClick");
    if ([self.delegate respondsToSelector:@selector(statusToolBar:didAttitudeButtonClicked:withCallBack:)]) {
        [self.delegate statusToolBar:self didAttitudeButtonClicked:self.attitudeButton withCallBack:^{
            //改变 赞 按钮的图片
            switch (self.attitudeButton.tag) {
                case attitudeTypeUnlike://未点赞状态
                    if (self.status.attitudes_count) {//点赞数不为0，即attitudeButton显示数字
                        NSString *title = [NSString stringWithFormat:@"%d",self.status.attitudes_count + 1];
                        //设置attitudeButton的标题，即显示赞的数字
                        [self.attitudeButton setTitle:title forState:UIControlStateNormal];
                    } else {//点赞数为0
                        NSString *title = [NSString stringWithFormat:@"%d",1];
                        [self.attitudeButton setTitle:title forState:UIControlStateNormal];
                    }
                    //设置按钮的图片
                    [self.attitudeButton setImage:[UIImage imageNamed:@"timeline_icon_like"]
                                         forState:UIControlStateNormal];
                    //改变按钮的tag
                    self.attitudeButton.tag = attitudeTypeLike;
                    break;
                case attitudeTypeLike:
                    if (self.status.attitudes_count > 1) {
                        NSString *title = [NSString stringWithFormat:@"%ld",[self.attitudeButton.titleLabel.text integerValue] - 1];
                        [self.attitudeButton setTitle:title forState:UIControlStateNormal];
                    } else {
                        [self.attitudeButton setTitle:@"赞" forState:UIControlStateNormal];
                    }
                    //设置按钮的图片
                    [self.attitudeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
                    //设置按钮的tag
                    self.attitudeButton.tag = attitudeTypeUnlike;
                default:
                    break;
            }
            
        }];
    }
}

//添加分割线的方法
- (void)addDividers {
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:dividerLine];
    [self.dividers addObject:dividerLine];
}

//重写layOutSubViews方法
- (void)layoutSubviews {
    //分割线的宽度
    CGFloat dividerW = 1;
    NSUInteger dividerCount = self.dividerArray.count;//分割线数量
    NSUInteger buttonCount = self.buttonArray.count;//按钮数量
    
    //设置按钮的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = (self.frame.size.width - dividerCount * dividerW) / buttonCount;
    CGFloat buttonH = self.frame.size.height;
    for (int i = 0; i < buttonCount; i++) {
        //取出按钮
        UIButton *button = self.buttonArray[i];
        //循环设置按钮的frame
        CGFloat buttonX = i * (buttonW + dividerW);//将分割线宽度合并到按钮中
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
    //设置分割线的frame
    CGFloat dividerY = 0;
    CGFloat dividerH = self.frame.size.height;
    for (int j = 0; j < dividerCount; j++) {
        //取出分割线
        UIImageView *dividerLine = self.dividerArray[j];
        //循环设置分割线的frame
        UIButton *tmpButton = self.buttonArray[j];
        CGFloat dividerX = CGRectGetMaxX(tmpButton.frame);
        
        dividerLine.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}

//重写status的setter方法
- (void)setStatus:(WeiboStatus *)status {
    _status = status;
    
    [self setupButton:self.retweetButton title:@"转发" count:status.reposts_count];
    [self setupButton:self.commentButton title:@"评论" count:status.comments_count];
    [self setupButton:self.attitudeButton title:@"赞" count:status.attitudes_count];
}

//设置工具条按钮内容的方法
- (void)setupButton:(UIButton *)button title:(NSString *)title count:(NSInteger)count {
    if (count) {//转发评论数不为0
        NSString *title = nil;
        if (count < 10000) {//转发评论数小于10000
            title = [NSString stringWithFormat:@"%ld",(long)count];
        } else {//转发评论数大于10000
            double doubleCount = count/10000;
            title = [NSString stringWithFormat:@"%.1f万",doubleCount];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [button setTitle:title forState:UIControlStateNormal];
    } else {
        [button setTitle:title forState:UIControlStateNormal];
    }
}
@end
















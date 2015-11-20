//
//  WeiboReweetStatus.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/4.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboReweetStatus.h"
#import "WeiboStatusFrame.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WeiboResizeImage.h"
#import "WeiboPicsView.h"
#import "STTweetLabel.h"

@interface WeiboReweetStatus()

/** * 被转发微博的昵称 */
@property (nonatomic,weak) UILabel *retweetNameLabel;

/** * 被转发微博的内容 */
@property (nonatomic,weak) UILabel *retweetContentLabel;

/** * 被转发微博的配图 */
@property (nonatomic,weak) WeiboPicsView *retweetPicView;

@end

@implementation WeiboReweetStatus

/**
 *  重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片
        self.image = [UIImage resizedImageWithName:@"timeline_retweet_background"];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        //被转发微博的内容
        UILabel * retweetContentLabel = [[UILabel alloc] init];
        
//        STTweetLabel *retweetContentLabel = [[STTweetLabel alloc] init];
        
        retweetContentLabel.font = WeiboStatusContentFont;
//        retweetContentLabel.backgroundColor = [UIColor clearColor];
//        retweetContentLabel.backgroundColor = [UIColor redColor];
        [self addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        
        //被转发微博的昵称
        UILabel * retweetNameLabel = [[UILabel alloc] init];
        retweetNameLabel.font = WeiboStatusNameFont;
        retweetNameLabel.textColor = [UIColor colorWithRed:88.0/255 green:112.0/255 blue:126.0/255 alpha:1.0];
//        retweetNameLabel.textColor = [UIColor blueColor];
//        retweetNameLabel.backgroundColor = [UIColor clearColor];
//        retweetNameLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:retweetNameLabel];
        self.retweetNameLabel = retweetNameLabel;
        
        //被转发微博的配图
        WeiboPicsView * retweetPicView = [[WeiboPicsView alloc] init];
        [self addSubview:retweetPicView];
        self.retweetPicView = retweetPicView;
    }
    return self;
}

/**
 *  重写statusFrame的stter方法
 */
- (void)setStatusFrame:(WeiboStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    
    //1.首先取出被转发微博
    WeiboStatus *retweetStatus = statusFrame.status.retweeted_status;
    WeiboUser *user = retweetStatus.user;
    
    //2.被转发微博的昵称
    self.retweetNameLabel.text = [NSString stringWithFormat:@"@%@",user.name];
    self.retweetNameLabel.frame = self.statusFrame.retweetNameLabelF;
    
    //3.被转发微博的内容
    self.retweetContentLabel.numberOfLines = 0;//设置换行
    self.retweetContentLabel.lineBreakMode = NSLineBreakByCharWrapping;//按字符换行
    //设置被转发微博retweetContentLabel缩进
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //        style.headIndent = self.statusFrame.retweetNameLabelF.size.width;
    //设置首行缩进
    style.firstLineHeadIndent = self.statusFrame.retweetNameLabelF.size.width;
    
    NSString *retweetContent = [NSString stringWithFormat:@":%@",retweetStatus.text];
    
    //设置Label的attributedText属性后无需再设置UILabel的text属性，因为attributedString初始化的时候已经设置过了
    self.retweetContentLabel.attributedText =
    [[NSAttributedString alloc] initWithString:retweetContent attributes:@{NSParagraphStyleAttributeName:style}];
    
    self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
    
    //被转发微博的配图
    if (retweetStatus.pic_urls.count) {
        self.retweetPicView.hidden = NO;
//        [self.retweetPicView sd_setImageWithURL:[NSURL URLWithString:retweetStatus.pic_ids] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.retweetPicView.picsArray = retweetStatus.pic_urls;
        self.retweetPicView.frame = self.statusFrame.retweetPicViewF;
    } else {
        self.retweetPicView.hidden = YES;
    }
}

@end

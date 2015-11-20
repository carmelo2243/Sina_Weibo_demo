//
//  WeiboTopView.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/4.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboTopView.h"
#import "WeiboStatusFrame.h"
#import "UIImage+WeiboResizeImage.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import "WeiboReweetStatus.h"
#import "WeiboPictureView.h"
#import "WeiboPicsView.h"

@interface WeiboTopView()

/** 头像view */
@property (nonatomic,weak) UIImageView *iconView;

/** 会员图标view */
@property (nonatomic,weak) UIImageView *vipView;

/** 配图view */
@property (nonatomic,weak) WeiboPicsView *picView;

/** 微博的昵称 */
@property (nonatomic,weak) UILabel *nameLabel;

/** 微博的发出时间 */
@property (nonatomic,weak) UILabel *timeLabel;

/** 微博的来源 */
@property (nonatomic,weak) UILabel *sourceLabel;

/** 微博的文字内容 */
@property (nonatomic,weak) UILabel *contentLabel;

/** 被转发微博的父控件 */
@property (nonatomic,weak) WeiboReweetStatus *retweetView;

@end

@implementation WeiboTopView

/**
 *  重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
//            self.backgroundColor = [UIColor blueColor];
        self.userInteractionEnabled = YES;
        
        //微博头像view
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        //会员图标view
        UIImageView *vipView = [[UIImageView alloc] init];
//        vipView.backgroundColor = [UIColor redColor];
        vipView.contentMode = UIViewContentModeCenter;
        [self addSubview:vipView];
        self.vipView = vipView;
        
        //微博配图view
        WeiboPicsView *picView = [[WeiboPicsView alloc] init];
        [self addSubview:picView];
        self.picView = picView;
        
        //微博的昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = WeiboStatusNameFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //微博发出时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = WeiboStatusTimeFont;
        timeLabel.textColor = [UIColor orangeColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //微博的来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = WeiboStatusSourceFont;
        sourceLabel.textColor = [UIColor grayColor];
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        //微博的内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = WeiboStatusContentFont;
        //    contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        //被转发微博的父控件
        WeiboReweetStatus *retweetView = [[WeiboReweetStatus alloc] init];
        [self addSubview:retweetView];
        self.retweetView = retweetView;
    }
    return self;
}

/**
 *  重写statusFrame的stter方法
 */
- (void)setStatusFrame:(WeiboStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    
    //先取出一个微博和用户
    WeiboStatus *status = statusFrame.status;
    WeiboUser *user = status.user;
    
    //微博头像view
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"group_avator_default"]];
    self.iconView.frame = self.statusFrame.iconViewF;
    
    //微博的昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    //会员图标view
    if (user.mbtype) {//用户是微博会员
        self.vipView.hidden = NO;
        self.nameLabel.textColor = [UIColor orangeColor];
        self.vipView.image = [UIImage imageNamed:
                              [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
        self.vipView.frame = self.statusFrame.vipViewF;
    } else {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    //微博配图view
    if (status.pic_urls.count) {
        self.picView.hidden = NO;
        self.picView.frame = self.statusFrame.picViewF;
//        [self.picView sd_setImageWithURL:[NSURL URLWithString:status.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.picView.picsArray = status.pic_urls;
    } else {
        self.picView.hidden = YES;
    }
    
    //微博发出时间
    self.timeLabel.text = status.created_at;
    
    CGFloat timeLabelX = self.statusFrame.nameLabelF.origin.x;
    CGFloat timeLabelY = CGRectGetMaxY(self.statusFrame.nameLabelF) + 0.5 * WeiboStatusCellBorder;
    CGSize timeLabelSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:WeiboStatusTimeFont}];
    self.timeLabel.frame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    //微博的来源
    self.sourceLabel.text = status.source;
    CGFloat sourceLabelX = CGRectGetMaxX(self.timeLabel.frame) + WeiboStatusCellBorder;
    CGFloat sourceLabelY = timeLabelY;
    CGSize sourceLabelSize = [status.source sizeWithAttributes:@{NSFontAttributeName:WeiboStatusSourceFont}];
    self.sourceLabel.frame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    //微博的内容
    self.contentLabel.text = status.text;
    self.contentLabel.numberOfLines = 0;//设置换行
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;//按字符换行
    self.contentLabel.frame = self.statusFrame.contentLabelF;
    
    //被转发微博的数据
    WeiboStatus *retweetStatus = status.retweeted_status;
    if (retweetStatus) {
        self.retweetView.hidden = NO;
        self.retweetView.frame = self.statusFrame.retweetViewF;
        //传递数据模型
        self.retweetView.statusFrame = self.statusFrame;
    } else {
        self.retweetView.hidden = YES;
    }
}

@end

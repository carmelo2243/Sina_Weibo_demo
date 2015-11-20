//
//  WeiboStatusCell.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-24.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboStatusCell.h"
#import "WeiboStatusFrame.h"
//#import "WeiboStatusToolBar.h"
#import "WeiboTopView.h"

@interface WeiboStatusCell()

/**---------------原创微博的子控件-start------------------------*/
/** *  顶部view */
@property (nonatomic, weak) WeiboTopView * topView;
/**---------------原创微博的子控件-end------------------------*/

/**---------------显示转发评论点赞数的工具条-start------------------------*/
/** * 微博的工具条 */
//@property (nonatomic,weak) WeiboStatusToolBar *statusToolBar;
/**---------------显示转发评论点赞数的工具条-end------------------------*/

@end

@implementation WeiboStatusCell

/**
 *  自定义一个快速初始化方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    NSString * cellID = @"weiboCell";
    //创建一个cell
    WeiboStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[WeiboStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
//    cell.backgroundColor = [UIColor blackColor];
    return cell;
}


/**
 *  自定义cell时候需要 重写initWithStyle:reuseIdentifier: 方法。
 *
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //一个微博cell可以拆分成三大部分：原创微博部分，被转发的微博，转发评论点赞数工具条。这三部分分别初始化。
//        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1.添加原创微博的子控件
        [self setupTopViewSubViews];
        
        //3.添加微博工具条(用于显示转发、评论、点赞数量)
        [self setupStautsToolBar];
    }
    return self;
}

//1.添加原创微博的子控件
- (void)setupTopViewSubViews {
    //设置选中时的背景
    self.selectedBackgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    
    //顶部的view
    WeiboTopView * topView = [[WeiboTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
//
//    //微博头像view
//    UIImageView * iconView = [[UIImageView alloc] init];
//    [self.topView addSubview:iconView];
//    self.iconView = iconView;
//    
//    //会员图标view
//    UIImageView * vipView = [[UIImageView alloc] init];
//    vipView.backgroundColor = [UIColor redColor];
////    vipView.contentMode = UIViewContentModeCenter;
//    [self.topView addSubview:vipView];
//    self.vipView = vipView;
//    
//    //微博配图view
//    UIImageView * picView = [[UIImageView alloc] init];
//    [self.topView addSubview:picView];
//    self.picView = picView;
//    
//    //微博的昵称
//    UILabel * nameLabel = [[UILabel alloc] init];
//    nameLabel.font = WeiboStatusNameFont;
//    [self.topView addSubview:nameLabel];
//    self.nameLabel = nameLabel;
//    
//    //微博发出时间
//    UILabel * timeLabel = [[UILabel alloc] init];
//    timeLabel.font = WeiboStatusTimeFont;
//    timeLabel.textColor = [UIColor orangeColor];
//    [self.topView addSubview:timeLabel];
//    self.timeLabel = timeLabel;
//    
//    //微博的来源
//    UILabel * sourceLabel = [[UILabel alloc] init];
//    sourceLabel.font = WeiboStatusSourceFont;
//    sourceLabel.textColor = [UIColor grayColor];
//    [self.topView addSubview:sourceLabel];
//    self.sourceLabel = sourceLabel;
//    
//    //微博的内容
//    UILabel * contentLabel = [[UILabel alloc] init];
//    contentLabel.font = WeiboStatusContentFont;
////    contentLabel.backgroundColor = [UIColor clearColor];
//    [self.topView addSubview:contentLabel];
//    self.contentLabel = contentLabel;
}

//3.添加微博工具条(用于显示转发、评论、点赞数量)
- (void)setupStautsToolBar {
    //微博的工具条
    WeiboStatusToolBar * statusToolBar = [[WeiboStatusToolBar alloc] init];
//    statusToolBar.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:statusToolBar];
    self.statusToolBar = statusToolBar;
}


/** 重写cell的setFrame方法
 *  适当减小cell的高度，保证cell有间隔
 *
 */
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 0.5 * WeiboStatusCellBorder;
    frame.size.height -= 0.85 * WeiboStatusCellBorder;
    [super setFrame:frame];
}


/** 重写frame模型的setter方法
 *  用来设置数据
 */
- (void)setStatusFrame:(WeiboStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    
    //原创微博的数据
    [self setupTopViewData];
    
    //工具条的数据
    [self setupStautsToolBarData];
}

//原创微博的数据设置
- (void)setupTopViewData {
    
    //先取出一个微博和用户
//    WeiboStatus *status = self.statusFrame.status;
//    WeiboUser *user = status.user;
    
    //顶部的view
    self.topView.frame = self.statusFrame.topViewF;
    
    //传递数据模型
    self.topView.statusFrame = self.statusFrame;
    
//    //微博头像view
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"group_avator_default"]];
//    self.iconView.frame = self.statusFrame.iconViewF;
//    
//    //微博的昵称
//    self.nameLabel.text = user.name;
//    self.nameLabel.frame = self.statusFrame.nameLabelF;
//    
//    //会员图标view
//    if (user.mbtype) {//用户是微博会员
//        self.vipView.hidden = NO;
//        self.nameLabel.textColor = [UIColor orangeColor];
//        self.vipView.image = [UIImage imageNamed:
//         [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
//        self.vipView.frame = self.statusFrame.vipViewF;
//    } else {
//        self.vipView.hidden = YES;
//        self.nameLabel.textColor = [UIColor blackColor];
//    }
//    
//    //微博配图view
//    if (status.thumbnail_pic) {
//        self.picView.hidden = NO;
//        self.picView.frame = self.statusFrame.picViewF;
//        [self.picView sd_setImageWithURL:[NSURL URLWithString:status.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
//    } else {
//        self.picView.hidden = YES;
//    }
//    
//    //微博发出时间
//    self.timeLabel.text = status.created_at;
//    
//    CGFloat timeLabelX = self.statusFrame.nameLabelF.origin.x;
//    CGFloat timeLabelY = CGRectGetMaxY(self.statusFrame.nameLabelF) + 0.5 * WeiboStatusCellBorder;
//    CGSize timeLabelSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:WeiboStatusTimeFont}];
//    self.timeLabel.frame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
//    self.timeLabel.frame = self.statusFrame.timeLabelF;
//    
//    //微博的来源
//    self.sourceLabel.text = status.source;
//    self.sourceLabel.frame = self.statusFrame.sourceLabelF;
//    
//    //微博的内容
//    self.contentLabel.text = status.text;
//    self.contentLabel.numberOfLines = 0;//设置换行
////    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    self.contentLabel.frame = self.statusFrame.contentLabelF;
}


//工具条的数据设置
- (void)setupStautsToolBarData {
    self.statusToolBar.frame = self.statusFrame.statusToolBarF;
    //传递微博模型
    self.statusToolBar.status = self.statusFrame.status;
}

@end


























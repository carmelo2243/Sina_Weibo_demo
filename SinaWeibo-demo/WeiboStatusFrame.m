//
//  WeiboStatusFrame.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-24.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboStatusFrame.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"
#import "WeiboPicsView.h"

@implementation WeiboStatusFrame

//重写setter方法，设置所有子控件的frame
- (void)setStatus:(WeiboStatus *)status {
    _status = status;
    
    //设置cell的高度:屏幕宽度 - 两侧的边距
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    /**---------------原创微博部分---------------------------------*/
    //1.设置topView的frame
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = cellW;
    CGFloat topViewH = 0;
//    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    //* 头像的frame
    CGFloat iconViewX = 1.5 * WeiboStatusCellBorder;
    CGFloat iconViewY = iconViewX;
//    CGFloat iconViewH = nameLabelSize.height + timeLabelSize.height + 0.5 * WeiboStatusCellBorder;//头像的高度 = 昵称Label的高度 + 时间Label的高度 + 间距
    CGFloat iconViewH = 40;
    CGFloat iconViewW = iconViewH;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    //* 昵称的frame
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + WeiboStatusCellBorder;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [status.user.name sizeWithAttributes:@{NSFontAttributeName:WeiboStatusNameFont}];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY},nameLabelSize};
    
    //* 微博发出时间的frame
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelF) + 0.5 * WeiboStatusCellBorder;
    CGSize timeLabelSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:WeiboStatusTimeFont}];
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    //* 会员图标的frame
    if (status.user.mbtype) {
        CGFloat vipViewX = CGRectGetMaxX(_nameLabelF) + 0.5 * WeiboStatusCellBorder;
        CGFloat vipViewY = nameLabelY;
        CGFloat vipViewH = nameLabelSize.height;
        CGFloat vipViewW = vipViewH;
        _vipViewF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
    }
    
    //* 微博来源的frame
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelF) + WeiboStatusCellBorder;
    CGFloat sourceLabelY = timeLabelY;
    CGSize sourceLabelSize = [status.source sizeWithAttributes:@{NSFontAttributeName:WeiboStatusSourceFont}];
    _sourceLabelF = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    //* 微博正文内容的frame
    CGFloat contentLabelX = iconViewX;
    CGFloat contentLabelY = CGRectGetMaxY(_iconViewF) + WeiboStatusCellBorder;
    CGFloat contentLabelMaxW = topViewW - 2 * contentLabelX;
//    CGSize contentLabelSize = [status.text sizeWithAttributes:@{NSFontAttributeName:WeiboStatusContentFont}];
    CGSize contentLabelSize = [status.text boundingRectWithSize:CGSizeMake(contentLabelMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WeiboStatusContentFont} context:nil].size;
    _contentLabelF = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    //微博的配图
    if (status.pic_urls.count) {
        CGFloat picViewX = iconViewX;
        CGFloat picViewY = CGRectGetMaxY(_contentLabelF) + 0.618 * WeiboStatusCellBorder;
//        CGFloat picViewH = 76;
//        CGFloat picViewW = picViewH;
        CGSize picViewSize = [WeiboPicsView pictureViewSizeWithPicCount:(int)status.pic_urls.count];
        _picViewF = (CGRect){picViewX, picViewY, picViewSize};
    }
    /**---------------原创微博部分---------------------------------*/
    
    
    /**---------------被转发微博部分---------------------------------*/
    if (status.retweeted_status) {//有被转发的微博
        //被转发微博的父控件
//        CGFloat retweetViewX = contentLabelX;
//        CGFloat retweetViewY = CGRectGetMaxY(_contentLabelF) + 0.5 * WeiboStatusCellBorder;
//        CGFloat retweetViewW = contentLabelMaxW;
        CGFloat retweetViewX = topViewX;
        CGFloat retweetViewY = CGRectGetMaxY(_contentLabelF) + 0.5 * WeiboStatusCellBorder;
        CGFloat retweetViewW = topViewW;
        CGFloat retweetViewH = 0;
//        _retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        
        //被转发微博的昵称
        CGFloat retweetNameLabelX = iconViewX;
        CGFloat retweetNameLabelY = WeiboStatusCellBorder;
        NSString * retweetName = [NSString stringWithFormat:@"@%@",status.retweeted_status.user.name];
        CGSize nameLabelSize = [retweetName sizeWithAttributes:@{NSFontAttributeName:WeiboStatusNameFont}];
        _retweetNameLabelF = (CGRect){{retweetNameLabelX, retweetNameLabelY}, nameLabelSize};
        
        //被转发微博的正文
        CGFloat retweetContentLabelX = retweetNameLabelX;
//        CGFloat retweetContentLabelY = CGRectGetMaxY(_retweetNameLabelF) + 0.4 * WeiboStatusCellBorder;
        CGFloat retweetContentLabelY = retweetNameLabelY;
        CGFloat retweetContentLabelMaxW = retweetViewW - 2 * retweetContentLabelX;
        
        //被转发的正文长度应包含昵称的长度，否则会因缩进导致最后的文字被遮挡
        NSString * retweetContent = [NSString stringWithFormat:@"@%@:%@",retweetName,status.retweeted_status.text];
//        NSLog(@"retweetContent:%@",retweetContent);
//        CGRect retweetContentRect = [retweetContent
//                                     boundingRectWithSize:CGSizeMake(retweetContentLabelMaxW, MAXFLOAT)
//                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                     attributes:@{NSFontAttributeName:WeiboStatusContentFont}
//                                     context:nil];
//        NSLog(@"\nretweetContent:%@\nretweetContentRect:%@",retweetContent,NSStringFromCGRect(retweetContentRect));
        CGSize retweetContentLabelSize =
            [retweetContent
             boundingRectWithSize:CGSizeMake(retweetContentLabelMaxW, MAXFLOAT)
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:WeiboStatusContentFont}
                         context:nil].size;
//            [status.retweeted_status.text
//             boundingRectWithSize:CGSizeMake(retweetContentLabelMaxW, MAXFLOAT)
//                         options:NSStringDrawingUsesLineFragmentOrigin
//                      attributes:@{NSFontAttributeName:WeiboStatusContentFont}
//                         context:nil].size;
        
        _retweetContentLabelF = (CGRect){{retweetContentLabelX, retweetContentLabelY}, retweetContentLabelSize};
        
        //被转发微博的配图
        if (status.retweeted_status.pic_urls.count) {
            CGFloat retweetPicViewX = retweetContentLabelX;
            CGFloat retweetPicViewY = CGRectGetMaxY(_retweetContentLabelF) + WeiboStatusCellBorder;
//            CGFloat retweetPicViewW = 76;
//            CGFloat retweetPicViewH = retweetPicViewW;
            CGSize retweetPicViewSize = [WeiboPicsView pictureViewSizeWithPicCount:(int)status.retweeted_status.pic_urls.count];
//            _retweetPicViewF = CGRectMake(retweetPicViewX, retweetPicViewY, retweetPicViewW, retweetPicViewH);
            _retweetPicViewF = (CGRect){retweetPicViewX, retweetPicViewY, retweetPicViewSize};
            
            retweetViewH = CGRectGetMaxY(_retweetPicViewF);
        } else { //被转发微博 没有配图
            retweetViewH = CGRectGetMaxY(_retweetContentLabelF);
        }
        retweetViewH += WeiboStatusCellBorder;
        _retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        
        topViewH = CGRectGetMaxY(_retweetViewF);
    } else {//没有被转发的微博
        //判断原创微博是否有配图
        if (status.pic_urls.count) {//有配图
            topViewH = CGRectGetMaxY(_picViewF);
        } else {//没有配图
            topViewH = CGRectGetMaxY(_contentLabelF);
        }
        topViewH += WeiboStatusCellBorder;
    }
    /**---------------被转发微博部分---------------------------------*/
//    topViewH += WeiboStatusCellBorder;
    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    /**---------------微博工具条部分---------------------------------*/
    //
    CGFloat statusToolBarX = topViewX;
    CGFloat statusToolBarY = CGRectGetMaxY(_topViewF);
    CGFloat statusToolBarW = topViewW;
    CGFloat statusToolBarH = 33;
    _statusToolBarF = CGRectMake(statusToolBarX, statusToolBarY, statusToolBarW, statusToolBarH);
    /**---------------微博工具条部分---------------------------------*/
    
    //cell的高度
    _cellHeight = CGRectGetMaxY(_statusToolBarF) + 0.7 * WeiboStatusCellBorder;
}
@end

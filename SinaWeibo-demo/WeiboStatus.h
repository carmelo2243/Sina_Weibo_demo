//
//  WeiboStatus.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboUser;

@interface WeiboStatus : NSObject

/**
 *  微博id
 */
@property (nonatomic,copy) NSString *idstr;

/**
 *  微博信息内容
 */
@property (nonatomic,copy) NSString *text;

/**
 *  微博发出时间
 */
@property (nonatomic,copy) NSString *created_at;

/**
 *  微博来源
 */
@property (nonatomic,copy) NSString *source;

/**
 *  微博的配图
 */
//@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic,strong) NSArray *pic_urls;

/**
 *  微博转发数
 */
@property (nonatomic,assign) int reposts_count;

/**
 *  微博评论数
 */
@property (nonatomic,assign) int comments_count;

/**微博点赞数*/
@property (nonatomic,assign) int attitudes_count;

/**
 *  微博作者的用户信息字段
 */
@property (nonatomic,strong) WeiboUser *user;

/**
 *  被转发的微博
 */
@property (nonatomic, strong) WeiboStatus *retweeted_status;

//+ (instancetype)statusWithDict:(NSDictionary *)dict;
//- (instancetype)initWithDict:(NSDictionary *)dict;


/**----------------------新浪返回的数据中，关于一条微博的部分--------------------------------
 *  {
        "statuses": [
            {
                "created_at": "Tue May 31 17:46:55 +0800 2011",
                "id": 11488058246,
                "text": "求关注。"，
                "source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>",
                "reposts_count": 8,
                "comments_count": 9,
                "user": {
                    "id": 1404376560,
                    "name": "zaku",
                    "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
                }
            },
            ...
        ],
        "ad": [
            {
                "id": 3366614911586452,
                "mark": "AB21321XDFJJK"
            },
        ...
        ],
        "previous_cursor": 0,                   // 暂未支持
        "next_cursor": 11488013766,    // 暂未支持
        "total_number": 81655
    }
 ----------------------新浪返回的数据中，关于一条微博的部分--------------------------------*/

@end

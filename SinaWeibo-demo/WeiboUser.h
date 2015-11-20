//
//  WeiboUser.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUser : NSObject

/**
 *  用户id
 */
@property (nonatomic,copy) NSString *idStr;

/**
 *  用户昵称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  用户的头像地址
 */
@property (nonatomic,copy) NSString *profile_image_url;

/**
 *  会员
 */
@property (nonatomic,assign) int mbtype;

/**
 *  会员等级
 */
@property (nonatomic,assign) int mbrank;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;


/**----------------------新浪返回的数据中，关于用户的部分--------------------------------
  "user": {
         "id": 1404376560,
         "name": "zaku",
         "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
     }
----------------------新浪返回的数据中，关于用户的部分--------------------------------*/
@end

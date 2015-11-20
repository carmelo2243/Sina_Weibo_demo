//
//  WeiboAccount.h
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-20.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAccount : NSObject<NSCoding>
//账号的属性

@property (nonatomic,copy) NSString *access_token;

/**
 *  账号的过期时间
 */
@property (nonatomic,strong) NSDate *dead_line;

/**
 *  access_token的生命周期
 */
@property (nonatomic,assign) long long expires_in;

/**
 *  access_token的生命周期
 */
@property (nonatomic,assign) long long remind_in;

/**
 *  当前授权用户的uid
 */
@property (nonatomic,assign) long long uid;

/**
 *  当前授权用户的昵称
 */
@property (nonatomic,copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (WeiboAccount *)account;
+ (void)saveAccount:(WeiboAccount *)account;
@end

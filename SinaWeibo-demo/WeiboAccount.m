//
//  WeiboAccount.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-20.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define WeiboAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.weibo"]

#import "WeiboAccount.h"

@implementation WeiboAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;

}

/**
 *  从文件中解析对象的时候调用（解码）
 *
 *  @param aDecoder <#aDecoder description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.dead_line = [aDecoder decodeObjectForKey:@"dead_line"];
        self.expires_in = [aDecoder decodeInt64ForKey:@"expires_in"];
        self.remind_in = [aDecoder decodeInt64ForKey:@"remind_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用（编码）
 *
 *  @param aCoder <#aCoder description#>
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.dead_line forKey:@"dead_line"];
    [aCoder encodeInt64:self.expires_in forKey:@"expires_in"];
    [aCoder encodeInt64:self.remind_in forKey:@"remind_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

/**
 *  保存账号
 *
 *  @param account 要保存的账号
 */
+ (void)saveAccount:(WeiboAccount *)account {
    
    //计算账号过期时间
    NSDate * date = [NSDate date];
    account.dead_line = [date dateByAddingTimeInterval:account.expires_in];
    
    //归档
    [NSKeyedArchiver archiveRootObject:account toFile:WeiboAccountFile];
}

/**
 *  取出账号
 */
+ (WeiboAccount *)account {
    //先取得账号
    WeiboAccount * account = [NSKeyedUnarchiver unarchiveObjectWithFile:WeiboAccountFile];
    
    //然后判断账号是否过期
    NSDate * now = [NSDate date];
    if ([account.dead_line compare:now] == NSOrderedDescending) {//过期时间 > 当前时间，说明还没过期
        return account;
    } else {//说明账号过期
        return nil;
    }
}

@end

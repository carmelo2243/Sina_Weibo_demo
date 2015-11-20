//
//  WeiboUser.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-22.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboUser.h"

@implementation WeiboUser

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self == [super init]) {
        self.idStr = dict[@"idStr"];
        self.name = dict[@"name"];
        self.profile_image_url = dict[@"profile_image_url"];
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

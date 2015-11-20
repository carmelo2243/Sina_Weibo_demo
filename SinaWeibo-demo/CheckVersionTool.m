//
//  CheckVersionTool.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-20.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "CheckVersionTool.h"
#import "WeiboTabBarController.h"
#import "NewfeatureViewController.h"

@implementation CheckVersionTool
+ (void)checkVersionForController {
    //通过版本号判断是否显示新特性
    NSString * key = @"CFBundleVersion";//plist中与版本号对应的key
    //取出上次版本号
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastVersion = [defaults stringForKey:key];
//    NSLog(@"lastVersion:%@",lastVersion);
    
    //取出当前版本号
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    NSLog(@"currentVersion:%@ \ninfoDictionary:%@",currentVersion,[NSBundle mainBundle].infoDictionary);
    
    //上次版本号与当前版本号进行比较
    if ([currentVersion isEqualToString:lastVersion]) {//如果当前版本号与之前的一样
        //显示状态栏
//        application.statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        //显示微博内容
        [UIApplication sharedApplication].keyWindow.rootViewController = [[WeiboTabBarController alloc] init];
    } else {//如果当前版本号与存储的不一样
        //显示新特性
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NewfeatureViewController alloc] init];
        
        //保存新的版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }

}
@end

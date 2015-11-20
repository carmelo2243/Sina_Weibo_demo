//
//  AppDelegate.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-25.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboTabBarController.h"
#import "NewfeatureViewController.h"
#import "OAuthViewController.h"
#import "WeiboAccount.h"
#import "CheckVersionTool.h"
#import "SDWebImageManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //设置window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
//    self.window.rootViewController = [[WeiboTabBarController alloc] init];
//    self.window.rootViewController = [[NewfeatureViewController alloc] init];
//    self.window.rootViewController = [[OAuthViewController alloc] init];
    
    //先检查是否存储了授权账号
    WeiboAccount * account = [WeiboAccount account];
    
    if (account) {//存储了授权账号，接下来检查版本号，然后选择控制器
        [CheckVersionTool checkVersionForController];
    } else {//没有存储授权账号，跳到授权页面进行授权，然后再选择控制器
        self.window.rootViewController = [[OAuthViewController alloc] init];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    //停止下载图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    //清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end

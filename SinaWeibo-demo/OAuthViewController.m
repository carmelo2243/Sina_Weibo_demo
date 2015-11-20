//
//  OAuthViewController.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-14.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

//https://www.baidu.com/?code=0ac3b1d7ab9ddb53700f081709b52fd7
//https://www.baidu.com/?code=670008369ebe4ab71ef521ccf8d5c093

#import "OAuthViewController.h"
#import "AFNetworking.h"
#import "WeiboAccount.h"
#import "CheckVersionTool.h"
#import "MBProgressHUD+MJ.h"

@interface OAuthViewController ()<UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加一个webView
    UIWebView * webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    //加载授权页面
    NSURL * url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=3441002428&redirect_uri=http://www.baidu.com&response_type=code"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

//在授权页面隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 实现webView的代理方法

/**
 *  当 webView 开始加载的时候调用该方法
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //显示提醒卡
    [MBProgressHUD showMessage:@"正在加载"];
}

/**
 *  当 webView 加载完毕的时候调用该方法
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //隐藏提示框
    [MBProgressHUD hideHUD];
}

/**
 *  当 webView 加载失败的时候调用该方法
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //隐藏提示框
    [MBProgressHUD hideHUD];
}

/**
 *  当webView发送一个请求之前都会先调用这个方法, 询问代理可不可以加载这个页面(请求)
 *
 *  @return YES : 可以加载页面,  NO : 不可以加载页面
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //请求的URL路径 http://www.baidu.com/?code=1ca20e802cac19434d6998cc223e5171
    NSString * urlStr = request.URL.absoluteString;
//    NSLog(@"request is : %@",request.URL.absoluteString);
    
    //查找code的范围
    NSRange range = [urlStr rangeOfString:@"code="];
    
    if (range.length) {
        //截取出code的值
        NSUInteger loc = range.location + range.length;
        NSString * code = [urlStr substringFromIndex:loc];
//        NSLog(@"--urlStr:%@,\n--code:%@",urlStr,code);
        
        //拿到code之后向新浪服务器发送请求，换取access_token
        [self accessTokenWithCode:(NSString *) code];
    }
    
    return YES;
}

/**
 *  该方法用于向新浪服务器发送请求来获取access_token
 *
 *  @param code 用于换取access_token的code
 */
- (void)accessTokenWithCode:(NSString *)code {
    //创建请求参数管理对象
    AFHTTPRequestOperationManager * manger = [[AFHTTPRequestOperationManager alloc] init];
    
    //封装请求参数
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"client_id"] = @"3441002428";
    params[@"client_secret"] = @"da6b6658a4f9ba3269f580004cbd2a3b";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com";
    
    //发送请求
    /**
     *  发送请求的方法
     *
     *  @param operation      <#operation description#>
     *  @param responseObject 请求成功后返回的响应数据，新浪微博返回的是一个字典
     *
     *  @return <#return value description#>
     */
    [manger POST:@"https://api.weibo.com/oauth2/access_token" parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {//请求成功就调用
        
        //将字典转化为模型
        WeiboAccount * account = [WeiboAccount accountWithDict:responseObject];
        
        //存储模型数据
        [WeiboAccount saveAccount:account];
        
        //检查版本号以选择控制器
        [CheckVersionTool checkVersionForController];
        
        //隐藏提示框
        [MBProgressHUD hideHUD];
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏提示框
        [MBProgressHUD hideHUD];
        
        //请求不成功就调用
        NSLog(@"请求失败。。。");
    }];
}

@end














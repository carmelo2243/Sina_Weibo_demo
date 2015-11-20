//
//  WeiboTabBarController.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-25.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboTabBarController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "WeiboTabBar.h"
#import "WeiboComposeController.h"
#import "CHTumblrMenuView.h"
#import "WeiboNavigationController.h"

@interface WeiboTabBarController () <WeiboTabBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  自定义TabBar
 */
@property(nonatomic, weak) WeiboTabBar *customTabBar;

@end

@implementation WeiboTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化TabBar
    [self setupTabBar];
//    self.tabBar.backgroundColor = [UIColor redColor];
    
    //初始化所以子控制器
    [self setupAllSubviews];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSystemTabBar) name:nil object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //移除系统TabBar中的按钮
    for (UIView * child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化TabBar的方法
 */
- (void)setupTabBar {
    WeiboTabBar * customTabBar = [[WeiboTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
//    customTabBar.backgroundColor = [UIColor redColor];
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  初始化所有子控件的方法
 */
- (void)setupAllSubviews {
    //首页
    HomeViewController * homeViewController = [[HomeViewController alloc] init];
    [self setupSubViewController:homeViewController
                          title:@"首页"
                      imageName:@"tabbar_home_os7"
            selectedImageName:@"tabbar_home_selected_os7"];
    //消息
    MessageViewController * msgViewCotl = [[MessageViewController alloc] init];
    [self setupSubViewController:msgViewCotl
                           title:@"消息"
                       imageName:@"tabbar_message_center_os7"
               selectedImageName:@"tabbar_message_center_selected_os7"];
    //广场
    DiscoverViewController * discoverViewCotl = [[DiscoverViewController alloc] init];
    [self setupSubViewController:discoverViewCotl
                           title:@"广场"
                       imageName:@"tabbar_discover_os7"
               selectedImageName:@"tabbar_discover_selected_os7"];
    //我
    MeViewController * meViewCotl = [[MeViewController alloc] init];
    [self setupSubViewController:meViewCotl
                           title:@"我"
                       imageName:@"tabbar_profile_os7"
               selectedImageName:@"tabbar_profile_selected_os7"];
}

/**
 *  初始化子控制器的方法
 *
 *  @param subViewController 要初始化的子控制器
 *  @param title             控制器的标题
 *  @param imageName         tabBaritem的图片名称
 *  @param selectedImageName tabBaritem的被选中时的图片名称
 */
- (void)setupSubViewController:(UITableViewController *)subViewController
                         title:(NSString *)title
                     imageName:(NSString *)imageName
             selectedImageName:(NSString *)selectedImageName {
    //1.初始化子控制器的标题
    subViewController.title = title;
    //设置tabBaritem的图片
    subViewController.tabBarItem.image = [UIImage imageNamed:imageName];
    //设置tabBaritem被选中时候的图片
    UIImage * selectedImage = [UIImage imageNamed:selectedImageName];
    subViewController.tabBarItem.selectedImage =
            [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //创建导航控制器并将要初始化的子控制器设置其根控制器
    WeiboNavigationController * nav = [[WeiboNavigationController alloc]
                                    initWithRootViewController:subViewController];
//    UINavigationController * nav = [[UINavigationController alloc]
//                                       initWithRootViewController:subViewController];
    
    //2.添加导航控制器
    [self addChildViewController:nav];
    
    //3.添加TabBar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:subViewController.tabBarItem];
//    NSLog(@"%@",subViewController.tabBarItem);
//    NSLog(@"%@",subViewController.tabBarItem.image);
//    NSLog(@"%@",subViewController.tabBarItem.title);
}

#pragma mark 实现WeiboTabBar的代理方法
/**
 *  点击tabBar上按钮进行跳转时调用此方法
 */
- (void)tabBar:(WeiboTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

/**
 *  点击加号按钮时调用此方法
 */
- (void)tabBar:(WeiboTabBar *)tabBar didClickedPlusButton:(WeiboPlusButton *)plusButton {
    
    //创建微博菜单
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    //创建“文字”按钮
    [menuView addMenuItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"tabbar_compose_idea"] andSelectedBlock:^{
        //点击“文字”按钮时弹出发微博控制器
        WeiboComposeController * composeController = [[WeiboComposeController alloc] init];
        //创建导航控制器并设置其根控制器
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:composeController];
        //model形式弹出一个写微博的控制器
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
    //创建“相册”按钮
    [menuView addMenuItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"tabbar_compose_photo"] andSelectedBlock:^{
        //打开相册
        UIImagePickerController *imgPC = [[UIImagePickerController alloc] init];
        imgPC.delegate = self;
        imgPC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPC animated:YES completion:nil];
    }];
    
    //创建“拍摄”按钮
    [menuView addMenuItemWithTitle:@"拍摄" andIcon:[UIImage imageNamed:@"tabbar_compose_camera"] andSelectedBlock:^{
        //
    }];

    //创建“签到”按钮
    [menuView addMenuItemWithTitle:@"签到" andIcon:[UIImage imageNamed:@"tabbar_compose_lbs"] andSelectedBlock:^{
        //
    }];

    //创建“点评”按钮
    [menuView addMenuItemWithTitle:@"点评" andIcon:[UIImage imageNamed:@"tabbar_compose_review"] andSelectedBlock:^{
        //
    }];

    //创建"更多"按钮
    [menuView addMenuItemWithTitle:@"更多" andIcon:[UIImage imageNamed:@"tabbar_compose_more"] andSelectedBlock:^{
        //
    }];
    
    [menuView show];
}

#pragma mark 实现UINavigationControllerDelegate的代理方法
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (viewController.hidesBottomBarWhenPushed) {
//        self.customTabBar.hidden = YES;
//    } else {
//        self.customTabBar.hidden = NO;
//    }
//}

#pragma mark 实现图片选择控制器UIImagePickerController的代理方法;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //关闭控制器
    [picker dismissViewControllerAnimated:NO completion:^{
        //关闭相册后弹出微博输入控制器
        WeiboComposeController * composeController = [[WeiboComposeController alloc] init];
        //创建导航控制器并设置其根控制器
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:composeController];
        //model形式弹出一个写微博的控制器
        [self presentViewController:nav animated:YES completion:nil];
        
        //设置选中图片
        composeController.composeImageView.image = info[UIImagePickerControllerOriginalImage];
    }];
    NSLog(@"info:%@",info);
}
@end

























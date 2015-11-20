//
//  HomeViewController.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-6-25.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+WeiboItem.h"
#import "WeiboTitleButton.h"
#import "AFNetworking.h"
#import "WeiboAccount.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import "WeiboStatusCell.h"
#import "WeiboStatusFrame.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "UIImage+WeiboResizeImage.h"
#import "WeiboStatusToolBar.h"
#import "WeiboRetweetController.h"
#import "WeiboCommentController.h"

@interface HomeViewController ()<UINavigationControllerDelegate,WeiboStatusToolBarDelegate>

/**
 *  存放模型的数组
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

/**
 *  控制器的标题按钮，用于显示当前用户的昵称
 */
@property (nonatomic,weak) WeiboTitleButton *titleButton;
@end

@implementation HomeViewController

/**
 *  重写statusFrames的getter方法，实现懒加载
 */
- (NSMutableArray *)statusFrames {
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //对cell进行一些初始化设置
    [self setupTableViewCell];
    
    //初始化导航栏
    [self setupNavigationBar];
    
    //设置标题按钮的数据
    [self setupTitleButtonData];
    
    //添加刷新控件
    [self setupRefreshControl];
}

/**
 *  对cell进行一些初始化设置
 */
- (void)setupTableViewCell {
    //去除UITableViewCell中的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //可以与用户交互
    self.tableView.userInteractionEnabled = YES;
    
    //设置tableview的背景
    self.tableView.backgroundColor = [UIColor colorWithRed:208 green:208 blue:208 alpha:0.9];
//    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WeiboStatusCellBorder, 0);
}

/**
 *  初始化导航栏
 */
- (void)setupNavigationBar {
    //添加左侧搜索按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] Highlighted:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] target:self action:@selector(friendSearch)];
    
    //添加右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_icon_radar"] Highlighted:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] target:self action:@selector(radar)];
    
    //添加中间按钮
    WeiboTitleButton * titleButton = [[WeiboTitleButton alloc] init];
//    titleButton.contentMode = UIViewContentModeCenter;
    titleButton.tag = 0;//表示按钮中下拉箭头的默认状态
    //设置titleButton的中心点位置
//    CGFloat titleCenterX = self.navigationController.navigationBar.frame.size.width * 0.5;
//    CGFloat titleCenterY = self.navigationController.navigationBar.frame.size.height *0.5;
//    titleButton.center = CGPointMake(titleCenterX, titleCenterY);
//    CGSize titleSize = [titleButton.titleLabel.text sizeWithAttributes:@{NSAttachmentAttributeName:titleButton.titleLabel.font}];
//    titleButton.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    
    //添加点击事件
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
}

/**
 *  设置标题按钮的数据
 */
- (void)setupTitleButtonData {
    //创建请求管理对象
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WeiboAccount account].access_token;
    params[@"uid"] = @([WeiboAccount account].uid);
    
    //发送请求
    [manger GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //字典转模型
        WeiboUser *user = [WeiboUser objectWithKeyValues:responseObject];
        //设置昵称
//        [self.titleButton setTitle:user.name forState:UIControlStateNormal];
        //保存昵称
        WeiboAccount *account = [WeiboAccount account];
        account.name = user.name;
        [WeiboAccount saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取titleButton内容失败");
    }];
}

/**
 *  添加刷新控件
 */
- (void)setupRefreshControl {
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    //监听refreshControl的状态改变
//    [refreshControl addTarget:self action:@selector(refreshControlStauteChange:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.tableView addSubview:refreshControl];
//    
//    //自动刷新，并不触发监听事件方法
//    [refreshControl beginRefreshing];
//    
//    //直接加载数据
//    [self refreshControlStauteChange:refreshControl];
//--------------------------------------------------------------------------
    
    //使用第三方框架实现上拉加载和下拉刷新
    //1.下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(refreshNewData)];
    [self.tableView headerBeginRefreshing];
    
    //2.上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

//下拉刷新数据
- (void)refreshNewData {
    //创建一个请求管理对象
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    
    //封装请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WeiboAccount account].access_token;//拿到access_token
//    params[@"count"] = @5;
    if (self.statusFrames.count) {
        WeiboStatusFrame *statusFrame = self.statusFrames[0];
        //返回 微博id比since_id大的微博
//        params[@"since_id"] = @([statusFrame.status.idstr intValue]);
        params[@"since_id"] = statusFrame.status.idstr;
//        NSLog(@"idstr:%@\nsince_id:%@",statusFrame.status.idstr,params[@"since_id"]);
    }
    
    //发送请求
    [manger GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //字典转模型
        NSArray *statusArray = [WeiboStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //        for (NSDictionary *dict in responseObject[@"statuses"]) {
        //            NSLog(@"dict:%@",dict[@"pic_urls"]);
        //        }
        
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (WeiboStatus *status in statusArray) {
            WeiboStatusFrame *statusFrame = [[WeiboStatusFrame alloc] init];
            //传递数据模型
            statusFrame.status = status;
            
            [statusFrameArray addObject:statusFrame];
        }
        
        //将新获取的数据和原有数据拼接
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:statusFrameArray];//将新获取的微博添加到数组
        [tmpArray addObjectsFromArray:self.statusFrames];//将原有旧数据添加到数组
        
        self.statusFrames = tmpArray;
        
        //刷新表格
        [self.tableView reloadData];
        
        //停止刷新
        [self.tableView headerEndRefreshing];
        
        //显示刷新出的微博数量
        [self showNewDataCount:statusFrameArray.count];
        
        //需要将
//        statusFrameArray = nil;
//        statusArray = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏提示框
        //        [MBProgressHUD hideHUD];
        //停止刷新
        [self.tableView headerEndRefreshing];
        NSLog(@"加载失败，请检查网络");
    }];
}

//显示新微博数量
- (void)showNewDataCount:(NSUInteger)count {
    //1.创建一个按钮
    UIButton *msgButton = [[UIButton alloc] init];
    msgButton.userInteractionEnabled = NO;//不需要与用户交互
    //将按钮添加到导航控制器的view上，位于导航栏的下面
    [self.navigationController.view insertSubview:msgButton belowSubview:self.navigationController.navigationBar];
    //2.设置按钮的frame
    CGFloat msgButtonH = 30;
    CGFloat msgButtonW = self.navigationController.navigationBar.frame.size.width;
    CGFloat msgButtonX = 0;
    CGFloat msgButtonY = CGRectGetMaxY(self.navigationController.navigationBar.frame) - msgButtonH;
    msgButton.frame = CGRectMake(msgButtonX, msgButtonY, msgButtonW, msgButtonH);
    //3.按钮的文字与格式
    [msgButton setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [msgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    msgButton.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"%lu 条新微博",(unsigned long)count];
        [msgButton setTitle:title forState:UIControlStateNormal];
    } else {
        [msgButton setTitle:@"没有新微博" forState:UIControlStateNormal];
    }
    //4.通过动画显示
    [UIView animateWithDuration:1.0 animations:^{
        //x方向移动为0，y方向的移动距离为msgButtonH + 2
        msgButton.transform = CGAffineTransformMakeTranslation(0, msgButtonH);
    } completion:^(BOOL finished) {//动画执行完成后
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            msgButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [msgButton removeFromSuperview];
        }];
    }];
}

//上拉加载更多数据
- (void)loadMoreData {
    //创建一个请求管理对象
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    
    //封装请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WeiboAccount account].access_token;//拿到access_token
    params[@"count"] = @10;
    if (self.statusFrames.count) {
        WeiboStatusFrame *statusFrame = [self.statusFrames lastObject];
        //获取 微博id小于等于max_id的微博
        long long maxId = [statusFrame.status.idstr longLongValue] - 1;
//        NSLog(@"maxID:%lld",maxId);
        params[@"max_id"] = @(maxId);
        //        NSLog(@"since_id:%@",params[@"since_id"]);
    }
    
    //发送请求
    [manger GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //字典转模型
        NSArray *statusArray = [WeiboStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (WeiboStatus *status in statusArray) {
            WeiboStatusFrame *statusFrame = [[WeiboStatusFrame alloc] init];
            //传递数据模型
            statusFrame.status = status;
            
            [statusFrameArray addObject:statusFrame];
        }
        
        //将新获取的数据和原有数据拼接
        [self.statusFrames addObjectsFromArray:statusFrameArray];//将新获取的微博添加到数组
        
        //刷新表格
        [self.tableView reloadData];
        
        //停止刷新
        [self.tableView footerEndRefreshing];
        //隐藏提示框
        //        [MBProgressHUD hideHUD];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //隐藏提示框
        //        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
        //停止刷新
        [self.tableView footerEndRefreshing];
        NSLog(@"加载失败，请检查网络");
    }];
}

//释放刷新控件
- (void)dealloc {
    [self.tableView removeHeader];
    [self.tableView removeFooter];
}

/**
 *  标题按钮的点击事件
 *
 */
- (void)titleClick:(WeiboTitleButton *)titleButton {
    //按钮的图标旋转
//    [UIView animateWithDuration:0.2 animations:^{
//        titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
////        titleButton.tag = 1;
//    }];
    if (titleButton.tag == 0) {
        [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
        titleButton.tag = 1;
    } else {
        [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        titleButton.tag = 0;
    }
    
    NSLog(@"点击了标题按钮");
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [UIView animateWithDuration:0.2 animations:^{
//        self.titleButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
//    }];
//}

/**
 *  左侧搜索按钮
 */
- (void)friendSearch {
    //弹出控制器
    UITableViewController *demoVC = [[UITableViewController alloc] init];
    demoVC.title = @"查找更多好友";
    [self.navigationController pushViewController:demoVC animated:YES];
//    NSLog(@"好友关注动态");
}

/**
 *  右侧雷达按钮
 */
- (void)radar {
    self.hidesBottomBarWhenPushed = YES;
    UITableViewController *demoVC = [[UITableViewController alloc] init];
    demoVC.title = @"雷达";
    
    [self.navigationController pushViewController:demoVC animated:YES];
//    NSLog(@"%@",self.navigationController.title);
}

#pragma mark 实现tableview的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    NSLog(@"%@",self.statuses.count);
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString * cellID = @"weiboCell";
//    //创建一个cell
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//    }
    
    //创建一个cell
    WeiboStatusCell * cell = [WeiboStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    cell.statusToolBar.delegate = self;
    
    /**
    //设置cell的数据
    //微博的文字
    WeiboStatus * status = self.statuses[indexPath.row];
//    NSLog(@"status is %@",status.user.profile_image_url);
    cell.textLabel.text = status.text;
//    cell.textLabel.text = @"kaka";
    //微博的昵称
    cell.detailTextLabel.text = status.user.name;
//    cell.detailTextLabel.text = @"sina";
    //微博的图片
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"tabbar_compose_button"]];
//    NSLog(@"%@",status.user.profile_image_url);
     */
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboCommentController *commentVC = [[WeiboCommentController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark 实现tableView的代理方法
/**
 *  返回cell的高度
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    
    return statusFrame.cellHeight;
}

#pragma mark 实现WeiboStatusToolBarDelegate代理方法
- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didRetweetButtonClicked:(UIButton *)button {
    WeiboRetweetController *retweetVC = [[WeiboRetweetController alloc] init];
    [self.navigationController pushViewController:retweetVC animated:YES];
}

- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didCommentButtonClicked:(UIButton *)button {
    WeiboCommentController *commentVC = [[WeiboCommentController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)statusToolBar:(WeiboStatusToolBar *)statusToolBar didAttitudeButtonClicked:(UIButton *)button withCallBack:(void (^)())callBack {
    callBack();
}

#pragma mark 实现UINavigationController的代理方法
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"%@",self.presentedViewController.title);
//}


/**
 *  使用系统控件实现 刷新控件的监听事件，此方法暂时用不到
 */
//- (void)refreshControlStauteChange:(UIRefreshControl *)refreshControl {
//    //创建一个请求管理对象
//    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
//    
//    //封装请求参数
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = [WeiboAccount account].access_token;//拿到access_token
//    //    params[@"count"] = @5;
//    if (self.statusFrames.count) {
//        WeiboStatusFrame *statusFrame = self.statusFrames[0];
//        //获取 微博id比since_id大的微博
//        params[@"since_id"] = statusFrame.status.idstr;
//        //        NSLog(@"since_id:%@",params[@"since_id"]);
//    }
//    
//    //发送请求
//    [manger GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //字典转模型
//        NSArray *statusArray = [WeiboStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        
//        //        for (NSDictionary *dict in responseObject[@"statuses"]) {
//        //            NSLog(@"dict:%@",dict[@"pic_urls"]);
//        //        }
//        
//        NSMutableArray *statusFrameArray = [NSMutableArray array];
//        for (WeiboStatus *status in statusArray) {
//            WeiboStatusFrame *statusFrame = [[WeiboStatusFrame alloc] init];
//            //传递数据模型
//            statusFrame.status = status;
//            
//            [statusFrameArray addObject:statusFrame];
//        }
//        
//        //将新获取的数据和原有数据拼接
//        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:statusFrameArray];//将新获取的微博添加到数组
//        [tmpArray addObjectsFromArray:self.statusFrames];//将原有旧数据添加到数组
//        
//        self.statusFrames = tmpArray;
//        
//        //刷新表格
//        [self.tableView reloadData];
//        
//        //停止刷新
//        [refreshControl endRefreshing];
//        //隐藏提示框
//        //        [MBProgressHUD hideHUD];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //隐藏提示框
//        //        [MBProgressHUD hideHUD];
//        //停止刷新
//        [refreshControl endRefreshing];
//        NSLog(@"加载失败，请检查网络");
//    }];
//}

@end























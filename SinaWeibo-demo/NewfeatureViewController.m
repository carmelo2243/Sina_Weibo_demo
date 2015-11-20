//
//  Newfeature.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-2.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define imageCount 2

#import "NewfeatureViewController.h"
#import "WeiboTabBarController.h"

@interface NewfeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化scrollView
    [self setupScrollView];
    
    //初始化pageControl
    [self setupPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化PageControl
 */
- (void)setupPageControl {
    //添加一个pageControl并设置页码
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = imageCount;
    
    //设置pageControl的frame
    CGFloat pageCenterX = self.view.frame.size.width * 0.5;
    CGFloat pageCenterY = self.view.frame.size.height - 30;
    pageControl.center = CGPointMake(pageCenterX, pageCenterY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    
    //设置pageControl的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

/**
 *  初始化scrollView
 */
- (void)setupScrollView {
    //添加一个scrollView
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    
    [self.view addSubview:scrollView];
    
    scrollView.delegate = self;
    
    //在scrollView中循环添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    for (int index = 0; index < imageCount; index ++) {
        //图片的横坐标
        CGFloat imageX = imageW * index;
        UIImageView * imageView = [[UIImageView alloc] init];
        //设置imageView的frame
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        //设置imageView的图片
        NSString * imageName = [NSString stringWithFormat:@"new_feature_%d",index + 1];
        imageView.image = [UIImage imageNamed:imageName];
        
        [scrollView addSubview:imageView];
        
        //添加开始微博的按钮
        if (index == imageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    //设置scrollView的一些属性
    scrollView.contentSize = CGSizeMake(imageW * imageCount, 0);//滚动范围
    scrollView.pagingEnabled = YES;//设置可分页
    scrollView.bounces = NO;//滚动到左侧时不可拉动
    scrollView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
}

/**
 *  设置最后一个imageView
 *
 *  @param imageView 要设置的imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView {
    //修改属性使imageView可以与用户交互
    imageView.userInteractionEnabled = YES;
    
    //---------设置“开始微博”按钮(startButton)-----------
    //添加“开始微博”按钮(startButton)
    UIButton * startButton = [[UIButton alloc] init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateNormal];
    
    //设置startButton的frame
    CGFloat startBtnCenterX = self.view.frame.size.width * 0.5;
    CGFloat startBtnCenterY = self.view.frame.size.height * 0.78;
    startButton.center = CGPointMake(startBtnCenterX, startBtnCenterY);
    startButton.bounds = (CGRect){CGPointZero,startButton.currentBackgroundImage.size};
    
    //设置startButton的文字
    [startButton setTitle:@"开始微博" forState:UIControlStateNormal];
    
    //添加startButton的点击事件
    [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:startButton];
    //---------设置“开始微博”按钮(startButton) end-----------
    
    //---------设置“分享微博”按钮(shareCheckBox)-------------
    UIButton * shareCheckBox = [[UIButton alloc] init];
    //设置图片和文字
    [shareCheckBox setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareCheckBox setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareCheckBox setTitle:@"与好友分享" forState:UIControlStateNormal];
    [shareCheckBox setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置默认状态是选中
    shareCheckBox.selected = YES;
    
    //设置shareCheckBox的frame
    CGFloat checkBoxCenterX = startBtnCenterX;
    CGFloat checkBoxCenterY = self.view.frame.size.height * 0.68;
    shareCheckBox.center = CGPointMake(checkBoxCenterX, checkBoxCenterY);
    shareCheckBox.bounds = CGRectMake(0, 0, 200, 30);
    
    //给shareCheckBox添加点击事件
    [shareCheckBox addTarget:self action:@selector(shareCheckBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:shareCheckBox];
    //---------设置“分享微博”按钮(shareCheckBox) end-------------
}

/**
 *  “开始微博”按钮的点击事件
 */
- (void)startButtonClick {
    //点击按钮时设置窗口的跟控制器为WeiboTabBarController，这样就可以显示微博内容了。
    self.view.window.rootViewController = [[WeiboTabBarController alloc] init];
}

/**
 *  “分享给好友”按钮的点击事件
 *
 *  @param checkBox 点击的checkBox
 */
- (void)shareCheckBoxClick:(UIButton *)checkBox {
    checkBox.selected = !checkBox.isSelected;
}

#pragma mark 实现scrollView的代理方法
/**
 *  滚动时改变页码
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //计算滚动范围
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //根据滚动范围计算页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
//    NSLog(@"pageInt:%d,%ld",pageInt,(long)self.pageControl.currentPage);
}

@end






















//
//  WeiboComposeController.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15-7-1.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#import "WeiboComposeController.h"
#import "WeiboTextView.h"
#import "AFNetworking.h"
#import "WeiboAccount.h"
#import "MBProgressHUD+MJ.h"
#import "WeiboComposeToolBar.h"
#import "WeiboTitleButtonView.h"

@interface WeiboComposeController ()<UITextViewDelegate,WeiboComposeToolBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  输入微博内容的textView
 */
@property(nonatomic,weak) WeiboTextView *textView;

/**
 *  写微博的工具条
 */
@property (nonatomic,weak) WeiboComposeToolBar *composeToolBar;

///**
// *  用于显示微博所发送图片的imageView
// */
//@property (nonatomic,weak) UIImageView *composeImageView;

@end

@implementation WeiboComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置textView
    [self setupTextView];
    
    //设置导航栏
    [self setupNavigationBar];
    
    //设置发微博工具条
    [self setupComposeToolBar];
    
    //设置用于显示微博所发送图片的imageView
    [self setupComposeImageView];
}

/**
 *  view加载完毕后，textView成为键盘第一响应者
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

/**
 *  scrollView滚动时，textView失去键盘焦点
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView endEditing:YES];
//    [self.textView resignFirstResponder];
}

/**
 *  设置textView
 */
- (void)setupTextView {
    //添加一个文本输入框
    WeiboTextView * textView = [[WeiboTextView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    //添加文字监听通知,控制“发送”按钮是否可用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:textView];
    
    //添加键盘监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  键盘的监听通知：在键盘即将显示时工具条一同出现
 */
- (void)keyboardWillAppear:(NSNotification *)note {
//    NSLog(@"AppearNote:%@",note);
    /**
     *  AppearNote:NSConcreteNotification 0x7ff1b5190ad0
        {name = UIKeyboardWillShowNotification;
         userInfo = {
             UIKeyboardAnimationCurveUserInfoKey = 7;
             UIKeyboardAnimationDurationUserInfoKey = "0.25";
             UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 216}}";
             UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 775}";
             UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 559}";
             UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
             UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
             }
         }
     *
     */
    //获得键盘的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //获得弹出键盘所用的时间
    CGFloat keyboardDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行工具条的动画
    [UIView animateWithDuration:keyboardDuration animations:^{
        self.composeToolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height);
    }];
}

/**
 *  键盘的监听通知：键盘即将退出时工具条一同隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note {
//    NSLog(@"HideNote:%@",note);
    /**
     *  HideNote:NSConcreteNotification 0x7ff1b505c170 
        {name = UIKeyboardWillHideNotification;
         userInfo = {
             UIKeyboardAnimationCurveUserInfoKey = 7;
             UIKeyboardAnimationDurationUserInfoKey = "0.25";
             UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 216}}";
             UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
             UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 775}";
             UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
             UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
             }
         }
     *
     */
    //获得隐藏键盘所用的时间
    CGFloat keyboardDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行工具条的动画
    [UIView animateWithDuration:keyboardDuration animations:^{
        self.composeToolBar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  设置导航栏
 */
- (void)setupNavigationBar {
    
    //设置导航栏标题
    WeiboTitleButtonView *titleButtonView = [WeiboTitleButtonView titleButtonView];
    self.navigationItem.titleView = titleButtonView;
//    self.title = @"发微博";
//    self.navigationItem.title = @"写微博";
    
    //1.添加左侧取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelItemClick)];
    //设置“取消”按钮的标题颜色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor darkGrayColor];
    
    //2.添加右侧“发送”按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendItemClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;//“发送”按钮默认不可用
    //设置右侧“发送”按钮的颜色
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}

/**
 *  设置发微博的工具条，默认位置是在屏幕下方
 */
- (void)setupComposeToolBar {
    WeiboComposeToolBar *composeToolBar = [[WeiboComposeToolBar alloc] init];
    composeToolBar.delegate = self;
    
    //设置WeiboComposeToolBar
    CGFloat barX = 0;
    CGFloat barH = 44;
    CGFloat barY = self.view.frame.size.height - barH;
    CGFloat barW = self.view.frame.size.width;
    composeToolBar.frame = CGRectMake(barX, barY, barW, barH);
    
    [self.view addSubview:composeToolBar];
    self.composeToolBar = composeToolBar;
}

/**
 *  设置用于显示微博所发送图片的imageView
 */
- (void)setupComposeImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5, 120, 96, 96);
    [self.textView addSubview:imageView];
    self.composeImageView = imageView;
}

/**
 *  监听微博输入文本框通知的方法
 */
- (void)textChange {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length;
}

/**
 *  移除通知
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  取消发微博
 */
- (void)cancelItemClick {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
//        [self.textView resignFirstResponder];
//        NSLog(@"取消");
    }];
}

/**
 *  发送微博
 */
- (void)sendItemClick {
    
    //判断要发送的微博是否带有图片
    if (self.composeImageView.image) {//微博中有图片
        [self sendStatusWithPic];
    } else {//微博没有图片
        [self sendStatusWithoutPic];
    }
    
    //关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:^{
////        [self.textView resignFirstResponder];
//        NSLog(@"发送微博");
//    }];
}

//发送没有图片的微博
- (void)sendStatusWithoutPic {
    //创建请求管理对象
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WeiboAccount account].access_token;
    params[@"status"] = self.textView.text;
    //发送请求
    [manger POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //发送成功 弹出提示
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //发送失败 弹出提示
        [MBProgressHUD showError:@"发送失败"];
    }];
}
//发送带有图片的微博
- (void)sendStatusWithPic {
    //创建请求管理对象
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WeiboAccount account].access_token;
    params[@"status"] = self.textView.text;
    //发送请求
    [manger POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {//在发送请求前会调用这个block，所以要在这个block中对图片进行处理，也就是在这里对pic参数进行封装
        //图片以二进制的形式发送
        NSData *data = UIImageJPEGRepresentation(self.composeImageView.image, 0.000005);//0.5为压缩比例
//        NSData *data = UIImagePNGRepresentation(self.composeImageView.image);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"" mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //发送成功 弹出提示
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //发送失败 弹出提示
        [MBProgressHUD showError:@"发送失败"];
        NSLog(@"operation:%@,\nerror:%@",operation,error);
    }];
}

#pragma mark 实现WeiboComposeToolBar的代理方法
- (void)composeToolBar:(WeiboComposeToolBar *)composeBar didClickButton:(WeiboComposeToolBarButtonType)buttonType {
    switch (buttonType) {
        case WeiboComposeToolBarButtonTypeCamera://点击相机按钮
            //打开相机
            [self openCamera];
            break;
        case WeiboComposeToolBarButtonTypePicture://点击相册按钮
            //打开相册
            [self openPictureLibrary];
            break;
        case WeiboComposeToolBarButtonTypeMention://点击@
            //打开@列表
            [self openMention];
            break;
        case WeiboComposeToolBarButtonTypeTrend://点击 #话题
            //打开话题
            [self openTrend];
            break;
        case WeiboComposeToolBarButtonTypeEmotion://点击表情
            //打开表情
            [self openEmotion];
            break;
            
        default:
            break;
    }
}

//打开相机
- (void)openCamera {
//    UIImagePickerController *imgPC = [[UIImagePickerController alloc] init];
//    imgPC.delegate = self;
//    imgPC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentViewController:imgPC animated:YES completion:nil];
    NSLog(@"点击了发微博工具条的相机按钮");
}

//打开相册
- (void)openPictureLibrary {
    UIImagePickerController *imgPC = [[UIImagePickerController alloc] init];
    imgPC.delegate = self;
    imgPC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPC animated:YES completion:nil];
}

//打开@列表
- (void)openMention {
    NSLog(@"点击了发微博工具条的@按钮");
}

//打开话题
- (void)openTrend {
    NSLog(@"点击了发微博工具条的#话题按钮");
}

//打开表情
- (void)openEmotion {
    NSLog(@"点击了发微博工具条的表情按钮");
}

#pragma mark 实现图片选择控制器UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //关闭控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //显示选中图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.composeImageView.image = image;
//    NSLog(@"info:%@",info);
}

@end

















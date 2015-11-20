//
//  WeiboNavigationController.m
//  
//
//  Created by SunZW on 15/11/9.
//
//

#import "WeiboNavigationController.h"

@interface WeiboNavigationController ()

@end

@implementation WeiboNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//
//}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = NO;
    
    return [super popToViewController:viewController animated:animated];
}

@end

//
//  BaseViewController.m
//  Lock
//
//  Created by 李云鹏 on 16/3/15.
//  Copyright © 2016年 yunPeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseConsumer];
    // 获取系统自带滑动手势的target对象
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}

- (void)baseConsumer
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//    backItem.title = @"";
//    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
//    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"backToPopAgo.png"] resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//        [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"backToPop.png"] resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    }
//    self.navigationItem.backBarButtonItem = backItem;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    //自定义返回按钮
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.tabBarItem.title = @"_____";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.tabBarItem.title = @"";
}

- (void)didReceiveMemoryWarning
{
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

@end

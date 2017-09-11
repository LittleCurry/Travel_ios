//
//  AppDelegate.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RecommendViewController.h"
#import "MeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    // 登录相关的client与sever, redis服务器存储的是key-value形式的键值对
    // 存储图片的方式要优化, 否则效率太低,,,
    // 图片是放到硬盘的某个位置, 对外给一个域名+地址, 取出来拼接
    // wxpay的支付后的回调body里没有参数, 原因是在初始化model时没有加& 这样没有给原对象赋值
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    UINavigationController *recomendNVC = [[UINavigationController alloc] initWithRootViewController:recommendVC];
    
    MeViewController *meVC = [[MeViewController alloc] init];
    UINavigationController *meNVC = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    homeNVC.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    recomendNVC.tabBarItem.image = [UIImage imageNamed:@"manage.png"];
    meNVC.tabBarItem.image = [UIImage imageNamed:@"me.png"];
    homeNVC.tabBarItem.selectedImage = [UIImage imageNamed:@"homing.png"];
    meNVC.tabBarItem.selectedImage = [UIImage imageNamed:@"ming.png"];
    homeNVC.title = @"首页";
    recomendNVC.title = @"足迹";
    meNVC.title = @"我的";
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.tabBar.tintColor = MAINCOLOR;
    tab.viewControllers = @[homeNVC, recomendNVC, meNVC];
    self.window.rootViewController = tab;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Travel_ios"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

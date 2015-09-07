//
//  AppDelegate.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-20.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import "AppDelegate.h"
#import "SimpleTabBarController.h"
#import "HomePageViewController.h"
#import "ShoppingMallViewController.h"
#import "MultilevelMenuViewController.h"

@interface AppDelegate ()
{
    SimpleTabBarController * _swTabBarController;
}
    
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //将tabbarController作为根视图控制器
    _swTabBarController=[[SimpleTabBarController alloc]init];
    self.window.rootViewController=_swTabBarController;
    
    [self prepareViewControllers];
    
    return YES;
}



//准备视图控制器（创建并设置tabbarController）
-(void)prepareViewControllers
{
    HomePageViewController * VC1=[[HomePageViewController alloc]init];
    [_swTabBarController addViewController:VC1 withTitle:@"首页" withImage:[UIImage imageNamed:@"bottom_home_icon"] withSelectedImage:[UIImage imageNamed:@"bottom_home_icon_on"]];
    
    ShoppingMallViewController * VC2=[[ShoppingMallViewController alloc]init];
    [_swTabBarController addViewController:VC2 withTitle:@"商城" withImage:[UIImage imageNamed:@"bottom_clothes_icon"] withSelectedImage:[UIImage imageNamed:@"bottom_clothes_icon_on"]];
    
    MultilevelMenuViewController * VC3=[[MultilevelMenuViewController alloc]init];
    [_swTabBarController addViewController:VC3 withTitle:@"分类" withImage:[UIImage imageNamed:@"bottom_sort_icon"] withSelectedImage:[UIImage imageNamed:@"bottom_sort_icon_on"]];
    
    UIViewController * VC4=[[UIViewController alloc]init];
    [_swTabBarController addViewController:VC4 withTitle:@"社区" withImage:[UIImage imageNamed:@"bottom_bbs_icon"] withSelectedImage:[UIImage imageNamed:@"bottom_bbs_icon_on"]];
    
    UIViewController * VC5=[[UIViewController alloc]init];
    [_swTabBarController addViewController:VC5 withTitle:@"我的" withImage:[UIImage imageNamed:@"bottom_like_icon"] withSelectedImage:[UIImage imageNamed:@"bottom_like_icon_on"]];
    
    
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

@end

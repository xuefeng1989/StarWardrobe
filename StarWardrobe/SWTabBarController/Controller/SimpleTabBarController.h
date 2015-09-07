//
//  SimpleTabBarController.h
//  CustomTabBarController
//
//  Created by qianfeng on 15-8-13.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTabBarController : UITabBarController

//添加视图控制器（包含图片和选中图片）
-(void)addViewController:(UIViewController *)viewController withTitle:(NSString *)title withImage:(UIImage *)image withSelectedImage:(UIImage *)selectedImage;

@end

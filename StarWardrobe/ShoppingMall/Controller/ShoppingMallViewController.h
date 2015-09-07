//
//  ShoppingMallViewController.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-21.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#warning -----“多极菜单”未解决的问题：
/*
 
 （1）没有保存菜单路径 
 （2）点击按钮之后，不能看到选中的是哪个二级／三级菜单（打勾）
 
 （3）－－－我觉得，应该设置三个menuView，这样才能记录是选中哪个；应该将二级／三级菜单的创建和定义都定义在一个view上，这样方便调用
 */


#import <UIKit/UIKit.h>

@interface ShoppingMallViewController : UIViewController

//分类数组
@property (nonatomic ,strong)NSArray * classesArray;

@end

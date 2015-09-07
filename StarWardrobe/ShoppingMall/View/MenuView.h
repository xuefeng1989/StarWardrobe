//
//  MenuView.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


/**
 *
 这个类的功能：
 （1）创建二级菜单视图和三级菜单视图
 （2）给二级菜单传递数据源（因为是属性，直接传递）
 
 */


#import <UIKit/UIKit.h>
#import "SecondMenuView.h"
#import "ThirdMenuView.h"

@interface MenuView : UIView

//数据源
@property (nonatomic ,strong)NSArray * dataArray;

//记录“第一级类别”的名字
@property (nonatomic ,strong)NSString * firstClassName;

//二级菜单视图
@property (nonatomic ,weak)SecondMenuView * secondMenuView;

//三级菜单视图
@property (nonatomic ,weak)ThirdMenuView * thirdMenuView;


@end

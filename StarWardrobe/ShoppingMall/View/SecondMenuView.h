//
//  SecondMenuView.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


/**
 *
 
 这个类的作用：
 （1）布局“二级菜单”视图
 （2）给“三级菜单”传递数据源（通过代理方法）
 
 */



#import <UIKit/UIKit.h>

//通过代理告诉“三级菜单”：数据源，“一级菜单名”和“二级菜单名”让它更新数据

@protocol SecondMenuViewDelegate <NSObject>

-(void)thirdMenuViewReloadData:(NSArray *)dataSource WithFirstClassName:(NSString *)firstClassName withSecondClassName:(NSString *)secondClassName;

@end


@interface SecondMenuView : UIView

//外部的数据源接口（并非内部tableView布局的数据源）
@property (nonatomic ,strong)NSArray * dataArray;

//记录“第一级类别”的名字
@property (nonatomic ,strong)NSString * firstClassName;

//代理（三级菜单）
@property (nonatomic ,weak)id<SecondMenuViewDelegate> delegate;

@end

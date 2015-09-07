//
//  MenuView.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


#import "MenuView.h"


@interface MenuView ()



@end


@implementation MenuView


#pragma  mark -  懒加载

//创建secondMenuView
-(SecondMenuView *)secondMenuView
{
    if (!_secondMenuView) {
        
        SecondMenuView * secondMenuView=[[SecondMenuView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
        [self addSubview:secondMenuView];
        _secondMenuView=secondMenuView;
    }
    return _secondMenuView;
}

//二级菜单
-(ThirdMenuView *)thirdMenuView
{
    if (!_thirdMenuView) {
        ThirdMenuView * thirdMenuView=[[ThirdMenuView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height)];
        [self addSubview:thirdMenuView];
        _thirdMenuView=thirdMenuView;
    }
    return _thirdMenuView;
}


#pragma mark - init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self.secondMenuView class];
        [self.thirdMenuView class];
        
        //设置代理
        self.secondMenuView.delegate=self.thirdMenuView;
        
    }
    return self;
}


#pragma mark - 分配数据
//通过dataArray的set方法更新table
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray=dataArray;
    
    //给“二级菜单视图”传递数据源
    self.secondMenuView.firstClassName=self.firstClassName;
    self.secondMenuView.dataArray=dataArray;
    
    //将“三级菜单视图”清空
    self.thirdMenuView.dataArray=nil;
    
}






@end

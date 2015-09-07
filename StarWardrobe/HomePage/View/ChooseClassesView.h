//
//  ChooseClassesView.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-20.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


#warning －问题：（1）选择分类视图：可能会有内存紧张问题（因为button在不断的创建和销毁）！！！！

/**
 *  选择分类视图
 */


#import <UIKit/UIKit.h>

@protocol ChooseClassesViewDelegate<NSObject>

//让HomePageVC中navigationBar中的scrollView更新
-(void)updateNavScrollView;

@end



@interface ChooseClassesView : UIView

//“总的分类”数组 和 “我的分类”数组
@property (nonatomic ,strong)NSArray * allClassesArray;

@property (nonatomic ,weak)id<ChooseClassesViewDelegate> delegate;


@end

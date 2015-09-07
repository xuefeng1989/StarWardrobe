//
//  MultilevelMenuView.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-23.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


/**
 *  
 
 －－－注释：
 
 这个视图包含的子视图：
 （1）navigationBar：“最外层”（几个button）是根据二级菜单决定的，或者是三级菜单（最终选中哪个，就是哪个）
 （2）bgView：“中间层”遮盖menuView 的滑动效果
 （3）menuView:“最底层”
    包含2.1 二级菜单视图firstMenuView &  三级菜单视图secondMenuView
        2.2 bottomBarImageView
 
 */



#import <UIKit/UIKit.h>

@interface MultilevelMenuView : UIView

//从外界传来的数据源，动态更新两个tableView的数据
@property (nonatomic ,strong)NSArray * dataSource;

@end

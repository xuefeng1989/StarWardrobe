//
//  ThirdMenuView.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondMenuView.h"
#import "DetalMenuModel.h"

//通过代理，更新viewcontroll而上的三级菜单名

@protocol ThirdMenuViewDelegate <NSObject>

-(void)updateThirdClassNameWithDetailMenuModel:(DetalMenuModel *)detailMenuModel;

@end



@interface ThirdMenuView : UIView<SecondMenuViewDelegate>

//三级菜单的数据源
@property (nonatomic ,strong)NSArray * dataArray;

@property (nonatomic ,weak)id<ThirdMenuViewDelegate>delegate;



@end

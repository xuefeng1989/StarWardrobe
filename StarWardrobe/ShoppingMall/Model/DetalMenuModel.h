//
//  DetalMenuModel.h
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

/**
 *  
 这个模型的作用：
 （1）记录详细的“菜单路径”，方便调用：一级菜单／二级菜单／三级菜单
 
 */


#import <Foundation/Foundation.h>

@interface DetalMenuModel : NSObject

@property (nonatomic ,copy)NSString * firstClassName;
@property (nonatomic ,copy)NSString * secondClassName;
@property (nonatomic ,copy)NSString * thirdClassName;

+(id)detalMenuModelWithDict:(NSDictionary *)dict;


@end

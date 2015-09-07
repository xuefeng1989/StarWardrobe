//
//  DetalMenuModel.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import "DetalMenuModel.h"

@implementation DetalMenuModel

+(id)detalMenuModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}



@end

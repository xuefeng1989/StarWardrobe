//
//  MultilevelMenuViewController.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-23.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import "MultilevelMenuViewController.h"
#import "MultilevelMenuView.h"

@interface MultilevelMenuViewController ()

//多级菜单视图
@property (nonatomic ,weak)MultilevelMenuView * multilevelMenuView;

//多级菜单的数据源
@property (nonatomic ,strong)NSArray * multilevelMenuDataSource;

@end

@implementation MultilevelMenuViewController


#pragma mark - 懒加载
-(MultilevelMenuView *)multilevelMenuView
{
    if (!_multilevelMenuView) {
        
        MultilevelMenuView * multilevelMenuView=[[MultilevelMenuView alloc]init];
        [self.view addSubview:multilevelMenuView];
        _multilevelMenuView=multilevelMenuView;
    }
    return _multilevelMenuView;
}


-(NSArray *)multilevelMenuDataSource
{
    if (!_multilevelMenuDataSource) {
        
        _multilevelMenuDataSource=
            @[
                  @[
                      @{@"FirstClassName":@"KTV",
                    @"SecondClassArray":@[@"ktv1",@"ktv2",@"ktv3"]},
                      @{@"FirstClassName":@"美食",
                    @"SecondClassArray":@[@"全部",@"甜点",@"火锅",@"日韩料理"]},
                      @{@"FirstClassName":@"酒店",
                    @"SecondClassArray":@[@"青年旅舍",@"客栈",@"豪华酒店",@"经济型酒店",@"主题酒店"]},
                      @{@"FirstClassName":@"电影",
                    @"SecondClassArray":@[@"大陆",@"欧美",@"日韩",@"香港"]}
                    ],
         
                @[
                    @{@"FirstClassName":@"朝阳区",
                    @"SecondClassArray":@[@"朝阳区1",@"朝阳区2",@"朝阳区3"]},
                    @{@"FirstClassName":@"海淀区",
                    @"SecondClassArray":@[@"海淀区1",@"海淀区2",@"海淀区3",@"日海淀区4"]},
                    @{@"FirstClassName":@"东城区",
                    @"SecondClassArray":@[@"东城区1",@"东城区2",@"东城区3",@"东城区4",@"东城区5"]},
                    @{@"FirstClassName":@"西城区",
                    @"SecondClassArray":@[@"西城区1",@"西城区2",@"西城区3",@"西城区4"]}
                  ],
                  
                @[
                      @{@"FirstClassName":@"好评优先",
                    @"SecondClassArray":@[@"好评优先1",@"好评优先2",@"好评优先3"]},
                      @{@"FirstClassName":@"离我最近",
                    @"SecondClassArray":@[@"离我最近1",@"离我最近2",@"离我最近3",@"离我最近4"]}
                ]
            ];
    }
    return _multilevelMenuDataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor=[UIColor cyanColor];
    
    
    //创建多级菜单视图
    [self.multilevelMenuView class];
    //传递数据源
    self.multilevelMenuView.dataSource=self.multilevelMenuDataSource;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

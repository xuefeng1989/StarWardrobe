//
//  ThirdMenuView.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#define BgColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]   //tableView和cell的背景颜色


#import "ThirdMenuView.h"



@interface ThirdMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
    //记录传递过来的一级菜单和二级菜单名
    NSString * _firstClassName;
    NSString * _secondClassName;
}

//呈现列表的tableView
@property (nonatomic ,weak)UITableView * tableView;

@end


@implementation ThirdMenuView

#pragma mark - initWithFrame方法

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        //创建tableView
        [self.tableView class];
    
        
    }
    return self;
}



#pragma  mark -  懒加载

//创建tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView * tableView=[[UITableView alloc]initWithFrame:self.bounds];
        
        tableView.backgroundColor=BgColor;
        
        //隐藏下滑线
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //设置代理
        tableView.delegate=self;
        tableView.dataSource=self;
        
        [self addSubview:tableView];
        _tableView=tableView;
    }
    return _tableView;
}



#pragma mark - 数据源的set方法

//（刷新数据）
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray=dataArray;
    
    [self.tableView reloadData];
}




#pragma mark - SecondMenuViewDelegate代理方法

//数据源是通过这个代理方法传来的
-(void)thirdMenuViewReloadData:(NSArray *)dataSource WithFirstClassName:(NSString *)firstClassName withSecondClassName:(NSString *)secondClassName
{
    self.dataArray=dataSource;
    
    //记录前两级菜单名
    _firstClassName=firstClassName;
    _secondClassName=secondClassName;
    
}



#pragma mark - tableView 的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
    }
    
    NSString * thirdClassName=self.dataArray[indexPath.row];
    
    cell.textLabel.text=thirdClassName;
    cell.backgroundColor=BgColor;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    
    return cell;
}


//选中cell后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * thirdClassName=self.dataArray[indexPath.row];
    
    //创建记录“菜单路径”的model
    DetalMenuModel * detailMenuModel=[[DetalMenuModel alloc]init];
    detailMenuModel.firstClassName=_firstClassName;
    detailMenuModel.secondClassName=_secondClassName;
    detailMenuModel.thirdClassName=thirdClassName;
    
    NSLog(@"---%@,%@,%@",detailMenuModel.firstClassName,detailMenuModel.secondClassName,detailMenuModel.thirdClassName);
    
    //通过代理方法，告诉viewController要更新为哪个三级菜单名
    [self.delegate updateThirdClassNameWithDetailMenuModel:detailMenuModel];

}




@end

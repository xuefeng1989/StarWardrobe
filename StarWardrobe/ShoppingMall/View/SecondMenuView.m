//
//  SecondMenuView.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-22.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#import "SecondMenuView.h"

@interface SecondMenuView ()<UITableViewDataSource,UITableViewDelegate>

//呈现列表的tableView
@property (nonatomic ,weak)UITableView * tableView;

//数据源（解析后的数据源）
@property (nonatomic ,strong)NSArray * dataSource;

@property (nonatomic ,strong)NSArray * thirdClassArrayDataSource;

//选中后的背景视图
@property (nonatomic ,strong)UIView * cellBgView;

@end

@implementation SecondMenuView


//init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        [self.tableView class];
    }
    return self;
}



#pragma  mark -  懒加载

//创建tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView * tableView=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        //隐藏下划线
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //设置代理
        tableView.delegate=self;
        tableView.dataSource=self;
        
        [self addSubview:tableView];
        _tableView=tableView;
    }
    return _tableView;
}


//cell的背景视图（为了显示选中后的背景颜色）
-(UIView *)cellBgView
{
    if (!_cellBgView) {
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        _cellBgView=view;
    }
    return _cellBgView;
}




#pragma mark - UITableViewDataSource 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
    }
    
    //显示箭头
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.dataSource[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    
    //设置cell选中后的状态
//    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    //设置cell选中状态下的view（方便设置背景颜色）
    cell.selectedBackgroundView=self.cellBgView;
    
    return cell;
}

//选中某个cell后，传递数据源给“三级菜单”
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取点击的二级菜单对应的三级菜单
    NSArray * thirdClassArray=self.thirdClassArrayDataSource[(int)indexPath.row];
    
    //通过代理给三级菜单视图传递数据源
    [self.delegate thirdMenuViewReloadData:thirdClassArray WithFirstClassName:self.firstClassName withSecondClassName:self.dataSource[(int)indexPath.row]];
}





#pragma mark - set方法获取并解析数据源

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray=dataArray;
    
    //遍历存值
    
    NSMutableArray * secondClassArray=[[NSMutableArray alloc]init];
    NSMutableArray * thirdClassArray=[[NSMutableArray alloc]init];
    
    for (NSDictionary * dict in dataArray) {
        NSString * value=[dict objectForKey:@"SecondClassName"];
        [secondClassArray addObject:value];
        
        NSArray * array=[dict objectForKey:@"thirdClass"];
        [thirdClassArray addObject:array];
    }
    
    //给数据源赋值
    self.dataSource=secondClassArray;
    
    //存储了所有三级菜单的数组
    self.thirdClassArrayDataSource=thirdClassArray;
    
    //更新数据
    [self.tableView reloadData];
    

    //在获取数据后，默认选中第一组第一行的数据
//    NSIndexPath * defaultSelectedIndex=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView selectRowAtIndexPath:defaultSelectedIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}




@end

//
//  MultilevelMenuView.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-23.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


#define MultilevelMenuHeight 300.0f //“展开后”整个菜单视图的高度
#define TopBarViewHeight 44.0f  //最上面的bar的高度(也是初始化之后菜单还没有展开之前的MultilevelMenuView的高度)

//包含firstMenuView&secondMenuView&bottomBarImageView的父视图高度
#define MenuViewHeight  (MultilevelMenuHeight-TopBarViewHeight)

#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏高

#define BottomBarImageViewHeight 21.0f   //最下面的条的高度（显示图片）

#define BgColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]   //tableView和cell的背景颜色


#import "MultilevelMenuView.h"

@interface MultilevelMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _firstMenuClassNameArray; //一级菜单名数组
    NSArray * _secondMenuClassNameArrays;    //二级菜单名数组组成的数组
    NSArray * _secondMenuClassNameArray;    //选中一级菜单名之后对应的二级菜单
    
    //记录一级菜单名和二级菜单名
    NSString * _firstClassName;
    NSString * _secondClassName;
    
    //记录一级菜单和二级菜单的下标
    NSInteger _firstClassIndex;
    NSInteger _secondClassIndex;
    
    UIButton * _selectedButton; //记录当前选中的button
    
}


//最上面的条视图
@property (nonatomic ,weak)UIView * topBarView;

//用来遮盖menuView滑动效果的背景图（在topBarView的后面，menuView的前面）
@property (nonatomic ,weak)UIView * bgView;

//用来放一级菜单视图和二级菜单视图的父view为了更好的偏移位置（伸展&收缩）
@property (nonatomic ,weak)UIView * menuView;

//一级菜单视图
@property (nonatomic ,weak)UITableView * firstMenuView;

//二级菜单视图
@property (nonatomic ,weak)UITableView * secondMenuView;

//最底下的imageView条（显示图片）
@property (nonatomic ,weak)UIImageView * bottomBarImageView;



@end


@implementation MultilevelMenuView

#pragma mark - 懒加载方法

//头部buttons条
-(UIView *)topBarView
{
    if (!_topBarView) {
        
        UIView * topBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TopBarViewHeight)];
        topBarView.backgroundColor=[UIColor purpleColor];
        [self addSubview:topBarView];
        _topBarView=topBarView;
    }
    return _topBarView;
}

//用来遮盖menuView滑动效果的背景图
-(UIView *)bgView
{
    if (!_bgView) {
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, -20, ScreenWidth, TopBarViewHeight+20)];
        bgView.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgView];
        _bgView=bgView;
    }
    return _bgView;
}


//包含一级菜单和二级菜单视图的父视图
-(UIView *)menuView
{
    if (!_menuView) {
        
        UIView * menuView=[[UIView alloc]initWithFrame:CGRectMake(0, TopBarViewHeight-MenuViewHeight, ScreenWidth, MenuViewHeight)];
        [self addSubview:menuView];
        _menuView=menuView;
    }
    return _menuView;
}



//一级菜单视图
-(UITableView *)firstMenuView
{
    if (!_firstMenuView) {
        UITableView * firstMenuView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, MenuViewHeight-BottomBarImageViewHeight)];
        firstMenuView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //设置代理
        firstMenuView.delegate=self;
        firstMenuView.dataSource=self;
        
        [self.menuView addSubview:firstMenuView];
        _firstMenuView=firstMenuView;
    }
    return _firstMenuView;
}


//二级菜单视图
-(UITableView *)secondMenuView
{
    if (!_secondMenuView) {
        UITableView * secondMenuView=[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, MenuViewHeight-BottomBarImageViewHeight)];
        secondMenuView.separatorStyle=UITableViewCellSeparatorStyleNone;
        secondMenuView.backgroundColor=BgColor;
        
        //设置代理
        secondMenuView.delegate=self;
        secondMenuView.dataSource=self;
        
        [self.menuView addSubview:secondMenuView];
        _secondMenuView=secondMenuView;
    }
    return _secondMenuView;
}


//地步显示边界图片的视图
-(UIImageView *)bottomBarImageView
{
    if (!_bottomBarImageView) {
        
        UIImageView * bottomBarImageView=[[UIImageView alloc]init];
        bottomBarImageView.frame=CGRectMake(0, MenuViewHeight-BottomBarImageViewHeight, ScreenWidth, BottomBarImageViewHeight);
        [bottomBarImageView setImage:[UIImage imageNamed:@"icon_chose_bottom"]];
        
        //添加手势（点击后收缩）
        bottomBarImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomBarImageViewTapGesture:)];
        [bottomBarImageView addGestureRecognizer:tapGesture];
        
        [self.menuView addSubview:bottomBarImageView];
        _bottomBarImageView=bottomBarImageView;
    }
    return _bottomBarImageView;
}


//地步边界bar的点击事件
-(void)bottomBarImageViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    //将menuView滑上去(并改变整个菜单视图的frame（包含topBar）)
    [UIView animateWithDuration:0.5 animations:^{
        self.menuView.center=CGPointMake(self.menuView.center.x,CGRectGetMaxY(self.topBarView.frame)-MenuViewHeight/2);
    }];
    self.frame=CGRectMake(0, 20, ScreenWidth, TopBarViewHeight);
}



#pragma mark - init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        //自定义的大小（从statusBar下面开始）
        self.frame=CGRectMake(0, 20, ScreenWidth, TopBarViewHeight);
        
        //创建子视图
        [self.menuView class];
        [self.bgView class];
        [self.topBarView class];
        
        [self.firstMenuView class];
        [self.secondMenuView class];
        [self.bottomBarImageView class];
        
    }
    return self;
}


#pragma mark - UITableViewDataSource代理方法

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据不同的tableView选择需要返回的行数
    if (tableView==self.firstMenuView) {
        return _firstMenuClassNameArray.count;
    }
    else{
        return _secondMenuClassNameArray.count;
    }
}


//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell=nil;
    
    if (tableView==self.firstMenuView) {
        
        //有则复用，没有则创建
        cell=[tableView dequeueReusableCellWithIdentifier:@"FirstMenuCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstMenuCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectedTextColor=[UIColor orangeColor];
        }
        cell.textLabel.text=_firstMenuClassNameArray[indexPath.row];
    }
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"SecondMenuCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SecondMenuCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.backgroundColor=BgColor;
            cell.selectedTextColor=[UIColor orangeColor];
        }
        cell.textLabel.text=_secondMenuClassNameArray[indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate代理方法

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.0f;
}

//选中某行后的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.firstMenuView) {
        //1.获取点击一级菜单后对应的二级菜单数据源
        _secondMenuClassNameArray=_secondMenuClassNameArrays[indexPath.row];
        
        //2.更新数据
        [self.secondMenuView reloadData];
        
        //3.记录一级菜单名和下标
        _firstClassName=_firstMenuClassNameArray[indexPath.row];
        _firstClassIndex=indexPath.row;
    }
    else{
        
        //1.记录二级菜单名和下标
        _secondClassName=_secondMenuClassNameArray[indexPath.row];
        _secondClassIndex=indexPath.row;
        
        //2.更新topBar上的当前选中的button的text值
        [_selectedButton setTitle:_secondClassName forState:UIControlStateNormal];
        
        //3.将当前的选择的菜单路径用字典的形式保存在userDefaults中
        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        
#warning －－－注：多级菜单：下面不能动态存储了！！！
        /*
         这里需要根据最外层的数组元素的个数，自己手动的命名要保存进userDefaults中的字典名
         （因为在topBar上不同的button，应该对应不同的“菜单路径字典”）
         */
        
        NSDictionary * menuPathDict=@{@"FirstClassName":_firstClassName,@"FirstClassIndex":@(_firstClassIndex),@"SecondClassName":_secondClassName,@"SecondClassIndex":@(_secondClassIndex)};
        
        //选中按钮是第一个
        if ((int)_selectedButton.tag==1) {
            [userDefaults setObject:menuPathDict forKey:@"MenuPath1"];
        }
    
        else if ((int)_selectedButton.tag==2){
            [userDefaults setObject:menuPathDict forKey:@"MenuPath2"];
        }
        else if((int)_selectedButton.tag==3){
            [userDefaults setObject:menuPathDict forKey:@"MenuPath3"];
        }
        
        //同步
        [userDefaults synchronize];
       
        
        //4.将menuView滑上去(并改变整个菜单视图的frame（包含topBar）)
        [UIView animateWithDuration:0.5 animations:^{
            self.menuView.center=CGPointMake(self.menuView.center.x,CGRectGetMaxY(self.topBarView.frame)-MenuViewHeight/2);
        }];
        self.frame=CGRectMake(0, 20, ScreenWidth, TopBarViewHeight);
        
    }
}


#pragma mark - dataSource的set方法

//数据源的set方法
//作用：（1）获取数据源   （2）创建topBar上的button
-(void)setDataSource:(NSArray *)dataSource
{
    //1.获取数据源
    
    _dataSource=dataSource;
    
    //2.读取每个菜单的第一个一级菜单名（先从userDefaults文件中读取，有就不用读取数据源中的数据，直接读取userDefaults中的数据，没有才要读数据源中的数据）
    
    
#warning ----注：这里也是手动的，不能自动得知有几个字典！！！（在写程序的时候，要根据topBar中的button个数来读取userDafaults中的字典）
    
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    NSMutableArray * buttonNameArray=[[NSMutableArray alloc]init];
    for (NSArray * menuNameArray in dataSource) {
        
        for (int i=0;i<(int)menuNameArray.count;i++) {
            
            if (i==0) {
                NSDictionary * menuNameDict = menuNameArray[i];
                NSString * firstClassName=[menuNameDict objectForKey:@"FirstClassName"];
                [buttonNameArray addObject:firstClassName];
            }
        }
    }
    
    //3.根据获取的数组，设置topBarView中的button
    
    int count=(int)buttonNameArray.count;
    CGFloat buttonWidth=ScreenWidth/count;
    CGFloat buttonHeight=TopBarViewHeight;
    
    for (int i=0;i<count;i++) {
        NSString * menuName = nil;
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight);
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        //从userDefaults中读取数据，看对应的button的字典是否已经存在
        NSString * menuPathDictKey=[NSString stringWithFormat:@"MenuPath%d",i+1];
        NSDictionary * menuPathDict=[userDefaults objectForKey:menuPathDictKey];
        //当字典存在，直接读取字典中的二级菜单名
        if (menuPathDict) {
            menuName=[menuPathDict objectForKey:@"SecondClassName"];
        }
        //字典不存在，读取buttonNameArray中的值
        else{
            menuName=buttonNameArray[i];
        }
        
        [button setTitle:menuName forState:UIControlStateNormal];
        
        
        //设置button的tag值(从1开始)，方便点击之后判断需要传递的数据源
        button.tag=i+1;
        
        // 给button设置点击事件，点击哪个，那么更新哪个才菜单对应的菜单列表
        [button addTarget:self action:@selector(topBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topBarView addSubview:button];
    }
    
    
    //4.默认选中topBarView上的第一个button
//    [self topBarButtonClick:(UIButton *)[self.topBarView viewWithTag:1]];
    
    
}

//top条上的button的点击事件
-(void)topBarButtonClick:(UIButton *)button
{
    //0.记录当前选中的button(并更新选中状态)
    _selectedButton.selected=!_selectedButton.selected;
    button.selected=YES;
    _selectedButton=button;
    
    
    //1.获取tag值对应的数据源
    
    NSMutableArray * firstMenuArray=[[NSMutableArray alloc]init];
    NSMutableArray * secondMenuArrays=[[NSMutableArray alloc]init];
    
    int num=(int)button.tag-1;
    NSArray * menuArray=self.dataSource[num];
    for (NSDictionary * menuDict in menuArray) {
        NSString * firstMenuName=[menuDict objectForKey:@"FirstClassName"];
        [firstMenuArray addObject:firstMenuName];
        
        //获取每个button对应的二级菜单的数组（为了减少遍历次数，提高性能）
        NSArray * secondMenus=[menuDict objectForKey:@"SecondClassArray"];
        [secondMenuArrays addObject:secondMenus];
        
    }
    _firstMenuClassNameArray=firstMenuArray;
    _secondMenuClassNameArrays=secondMenuArrays;
    
    _firstClassName=_firstMenuClassNameArray[0];
    _firstClassIndex=0;
    
    //2.更新一级菜单列表
    [self.firstMenuView reloadData];
    
    
    //3.实现展开视图后显示自己选择的一级和二级菜单cell
    
    //从userDefaults中获取菜单路径
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString * keyValue=[NSString stringWithFormat:@"MenuPath%d",(int)_selectedButton.tag];
    
    NSDictionary * menuPathDict=[userDefaults objectForKey:keyValue];
    
    //-------------------------------------------------------------------
    NSLog(@"keyValue:----%@\n dict:%@",keyValue,menuPathDict);

    
    
    
    //如果菜单路径为空，默认从第一个一级菜单开始
    if (!menuPathDict) {
        //-----注：下面这个方法只能让tableView选中相应的cell，但是不能够触发didSelectedRow这个代理方法，无法就这样更新二级菜单视图的内容
        NSIndexPath * defaultIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        //默认选中一级菜单的第0个cell
        [self.firstMenuView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        //更新二级菜单视图的数据
        _secondMenuClassNameArray=_secondMenuClassNameArrays[0];
        [self.secondMenuView reloadData];
        
        //默认选中第0个cell
        [self.secondMenuView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
    }
    //不为空，从字典中读取
    else{
        NSInteger firstClassIndex=[[menuPathDict objectForKey:@"FirstClassIndex"] intValue];
        NSInteger secondClassIndex=[[menuPathDict objectForKey:@"SecondClassIndex"]intValue];
        
        
         //选中之前选好的一级菜单的cell
        NSIndexPath * firstMenuIndexpath=[NSIndexPath indexPathForRow:firstClassIndex inSection:0];
        [self.firstMenuView selectRowAtIndexPath:firstMenuIndexpath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        
#warning   －－多级菜单： 问题：会超出范围！！！打开这个方法之后，选中的row的index会超出范围，所以必须让上面的方法（更新二级菜单视图）执行完成之后，在执行这个方法(selectRowAtIndexPath)才行！！！
        
        
        
        //更新二级菜单的数据
        _secondMenuClassNameArray=_secondMenuClassNameArrays[firstClassIndex];
            [self.secondMenuView reloadData];
        
           
        //选中之前选中的一级菜单对应的二级菜单的cell
        NSIndexPath * secondMenuIndexPath=[NSIndexPath indexPathForRow:secondClassIndex inSection:0];
            
        /*
        -------最好的做法是：下面的做法不要执行，不然总崩！！！！！！！－－－－－－－－－
        */
            
//            [self.secondMenuView selectRowAtIndexPath:secondMenuIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
      
    }
    
    
    
    //4.将menuView视图伸展出来
    
    //4.1.先将multilevelMenuView的frame设置为伸展状态
    self.frame=CGRectMake(0, 20, ScreenWidth, MultilevelMenuHeight);
    
    //4.2将menuView“滑”出来
    [UIView animateWithDuration:0.5 animations:^{
       
        self.menuView.center=CGPointMake(self.menuView.center.x, CGRectGetMaxY(self.topBarView.frame)+MenuViewHeight/2);
    }];

}





@end

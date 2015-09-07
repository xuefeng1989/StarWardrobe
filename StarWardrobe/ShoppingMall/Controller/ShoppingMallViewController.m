//
//  ShoppingMallViewController.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-21.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏高

#define NavBarHeight 44.0f  //navigationBar的高度

#define NavBarButtonHeight 42.0f  //菜单按钮的高度

#define NavBarLineViewHeight 1.0f   //红色下划线的高度

#define MenuViewHeight 300.0f   //菜单视图的高


#import "ShoppingMallViewController.h"
#import "MenuView.h"

@interface ShoppingMallViewController ()<ThirdMenuViewDelegate>


//自定义的navigationBar
@property (nonatomic ,weak)UIView * navigationBar;

//navigationBar中的红色下划线
@property (nonatomic ,weak)UIView * navBarLineView;

//菜单视图
@property (nonatomic ,weak)MenuView * menuView;

//记录选中的按钮（才知道要传入什么数据源）
@property (nonatomic ,weak)UIButton * selectedButton;


@end

@implementation ShoppingMallViewController


#pragma mark - viewDidLoad方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建navigationBar视图
    [self preparenNavBarWithClassesArray:self.classesArray];
    
    //创建“菜单视图”
    [self.menuView class];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}



#pragma mark - 懒加载
//classesArray数组
-(NSArray *)classesArray
{
    if (!_classesArray) {
        _classesArray=[[NSArray alloc]init];
        
        _classesArray=@[
          @{@"FirstClassName":@"全部",
            @"SecondClass":
  @[@{@"SecondClassName":@"KTV",
      @"thirdClass":@[@"ktv1",@"ktv2",@"ktv3"]},
  @{@"SecondClassName":@"美食",
    @"thirdClass":@[@"全部",@"甜点",@"火锅",@"日韩料理"]},
  @{@"SecondClassName":@"酒店",
    @"thirdClass":@[@"青年旅舍",@"客栈",@"豪华酒店",@"经济型酒店",@"主题酒店"]},
  @{@"SecondClassName":@"电影",
    @"thirdClass":@[@"大陆",@"欧美",@"日韩",@"香港"]}
    ]},
          @{@"FirstClassName":@"全城",
            @"SecondClass":
                @[@{@"SecondClassName":@"朝阳区",
                    @"thirdClass":@[@"ktv1",@"ktv2",@"ktv3"]},
                  @{@"SecondClassName":@"海淀区",
                    @"thirdClass":@[@"全部",@"甜点",@"火锅",@"日韩料理"]},
                  @{@"SecondClassName":@"东城区",
                    @"thirdClass":@[@"青年旅舍",@"客栈",@"豪华酒店",@"经济型酒店",@"主题酒店"]},
                  @{@"SecondClassName":@"西城区",
                    @"thirdClass":@[@"大陆",@"欧美",@"日韩",@"香港"]}
                  ]},
          @{@"FirstClassName":@"排序",
            @"SecondClass":
                @[@{@"SecondClassName":@"好评优先",
                    @"thirdClass":@[@"ktv1",@"ktv2",@"ktv3"]},
                  @{@"SecondClassName":@"离我最近",
                    @"thirdClass":@[@"全部",@"甜点",@"火锅",@"日韩料理"]},
                  @{@"SecondClassName":@"人均最低",
                    @"thirdClass":@[@"青年旅舍",@"客栈",@"豪华酒店",@"经济型酒店",@"主题酒店"]},
                  @{@"SecondClassName":@"实惠划算",
                    @"thirdClass":@[@"大陆",@"欧美",@"日韩",@"香港"]}
                  ]}];
        
    }
    return _classesArray;
}


//懒加载navigationBar
-(UIView *)navigationBar
{
    if (!_navigationBar) {
        UIView * navigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, NavBarHeight)];
        navigationBar.backgroundColor=[UIColor lightGrayColor];
        
        [self.view addSubview:navigationBar];
        
        _navigationBar=navigationBar;
    }
    return _navigationBar;
}


//懒加载navigationBar上的红色下划线
-(UIView *)navBarLineView
{
    if (!_navBarLineView) {
        UIView * lineView=[[UIView alloc]init];
        lineView.backgroundColor=[UIColor redColor];
        [self.navigationBar addSubview:lineView];
        _navBarLineView=lineView;
    }
    return _navBarLineView;
}


//懒加载”菜单视图“
-(MenuView *)menuView
{
    if (!_menuView) {
        
        MenuView * menuView=[[MenuView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, MenuViewHeight)];
        
        //设置代理，用来更新从三级菜单视图传过来的值
        menuView.thirdMenuView.delegate=self;
        
        [self.view addSubview:menuView];
        _menuView=menuView;
    }
    return _menuView;
}





#pragma mark -准备navigationBar

//总菜单
-(void)preparenNavBarWithClassesArray:(NSArray *)classArray
{
    //一级菜单
   NSMutableArray * firstClassArray=[[NSMutableArray alloc]init];
    for (NSDictionary * firstDict in classArray) {
        [firstClassArray addObject:[firstDict objectForKey:@"FirstClassName"]];
    }
    [self prepareFirstClassMenuWithArray:firstClassArray];
    
    
}

//一级菜单
-(void)prepareFirstClassMenuWithArray:(NSArray *)firstClassArray
{

    int count=(int)firstClassArray.count;
    CGFloat buttonWidth=ScreenWidth/count;
    
    
    //创建红色下划线
//    [self.navBarLineView class];
//    self.navBarLineView.frame=CGRectMake(0, NavBarButtonHeight, buttonWidth, NavBarLineViewHeight);
    
    
    //创建按钮
    for (int i=0;i<count;i++) {
        
        NSString * firstClassName=firstClassArray[i];
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        //为了button之间有分割线
        if (i!=2) {
            button.frame=CGRectMake(i*buttonWidth, 1, buttonWidth-1, NavBarButtonHeight);
        }
        else{
            button.frame=CGRectMake(i*buttonWidth, 1, buttonWidth, NavBarButtonHeight);
        }
        
        [button setTitle:firstClassName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [button setBackgroundColor:[UIColor whiteColor]];

        //添加点击事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //button的tag值，从1开始
        button.tag=i+1;
        
        [self.navigationBar addSubview:button];
        
    }
    
    //默认选中第一个按钮
    [self buttonClick:(UIButton *)[self.view viewWithTag:1]];
    
    
    
    
}


//menu按钮点击事件
-(void)buttonClick:(UIButton *)button
{
    //移动下划线
//    self.navBarLineView.center=CGPointMake(button.center.x, self.navBarLineView.center.y);
    
    //设置选中按钮
    self.selectedButton.selected=NO;
    button.selected=YES;
    self.selectedButton=button;
    
    //给选中按钮对应的二级菜单传递数据源
    //根据选中的button显示不同的内容
    [self prepareSecondMenuViewWithClassArray:self.classesArray];
    
}


#pragma mark - 二级菜单视图的创建
-(void)prepareSecondMenuViewWithClassArray:(NSArray *)classArray
{
    //根据当前的选中按钮是哪个，获取数据
    int num=(int)self.selectedButton.tag-1;
    
    NSDictionary * firstMenuDict=classArray[num];
    
    //获取二级菜单的数据数组
    NSArray * secondMenuArray=[firstMenuDict objectForKey:@"SecondClass"];
    
    //传递数据源并传递第一级类别的名字（方便记录）
    self.menuView.firstClassName=[firstMenuDict objectForKey:@"FirstClassName"];
    self.menuView.dataArray=secondMenuArray;
     
}

#pragma  mark - ThirdMenuViewDelegate代理方法

-(void)updateThirdClassNameWithDetailMenuModel:(DetalMenuModel *)detailMenuModel
{
    //更新button的名
    [self.selectedButton setTitle:detailMenuModel.thirdClassName forState:UIControlStateNormal];
}




@end

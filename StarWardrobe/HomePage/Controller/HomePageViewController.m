//
//  HomePageViewController.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-20.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

/**
 注：
 （1）为了方便点击button切换到不同的视图，不讲customNavigationBar封装了（不然会有很复杂的代理需要设置）
 */


#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏高

#define NavigationBarHeight 44.0f   //navigationBar的高度
#define LeftOrRightBtnWidthOrHeight 44.0f   //navigationBar上 左右按钮的宽高

#define NavBarButtonSpacing 7.0f    //navigationBar中的button距离上边界的间距
#define NavBarButtonWidth 70.0f //navigationBar上的button的宽
#define NavBarButtonHeight 30.0f //navigationBar上的button的高
#define NavBarLineHeight 1.0f   //button下方红色横线的高
#define NavBarLineWidth 40.0f   //button下方红色横线的宽


#import "HomePageViewController.h"
#import "ChooseClassesView.h"

@interface HomePageViewController ()<ChooseClassesViewDelegate>
{
    UIView * _lineView;
}

//自定制的navigationBar
@property (nonatomic ,strong)UIView  * customNavigationBar;

//navigationBar上的scrollView
@property (nonatomic ,weak)UIScrollView * navBarScrollView;

//选择分类视图
@property (nonatomic ,weak)ChooseClassesView * chooseClassesView;

//“我的分类”数组
@property (nonatomic ,strong)NSArray * myClassesArray;



@end

@implementation HomePageViewController


#pragma mark - viewDidLoad方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建navigationBar,并布局button
    [self prepareNavigationBar];
    
    
}

//viewWillAppear方法 －－方便实时更新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载方法

//创建选择分类视图
-(ChooseClassesView *)chooseClassesView
{
    if (!_chooseClassesView) {
        ChooseClassesView * chooseClassesView=[[ChooseClassesView alloc]initWithFrame:self.view.bounds];
        //设置代理
        chooseClassesView.delegate=self;
        
        [self.view addSubview:chooseClassesView];
        _chooseClassesView=chooseClassesView;
    }
    return _chooseClassesView;
}

//创建我的分类数组
//userDefaults中有，直接取，没有的话，初始化
-(NSArray *)myClassesArray
{
    if (!_myClassesArray) {
        
        //先查找userDefaults中是否已经有数据
        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        
        //1.没有数据，创建，初始化数据
        if (![userDefaults objectForKey:@"MyClassesArray"]) {
            //所有分类是固定的
            _myClassesArray=[[NSMutableArray alloc]initWithObjects:@"最新",@"热门",@"欧美",@"日韩",@"型男",@"本土",@"丰满",nil];
        }
        
        //2.已经创建过，直接添加userDefaults中的数据
        else if ([userDefaults objectForKey:@"MyClassesArray"]){
            _myClassesArray=[[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:@"MyClassesArray"]];
        }
        
    }
    return _myClassesArray;
}


//navigationBar
-(UIView *)customNavigationBar
{
    if (!_customNavigationBar) {
        UIView * customNavBar=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, NavigationBarHeight)];
        _customNavigationBar=customNavBar;
    }
    return _customNavigationBar;
}



-(UIScrollView *)navBarScrollView
{
    if (!_navBarScrollView) {
        //1.创建scrollView
        UIScrollView * navBarScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(LeftOrRightBtnWidthOrHeight,0, ScreenWidth-LeftOrRightBtnWidthOrHeight*2, NavigationBarHeight)];
        navBarScrollView.contentSize=CGSizeMake(NavBarButtonWidth*((int)self.myClassesArray.count),navBarScrollView.bounds.size.height);
        navBarScrollView.showsHorizontalScrollIndicator=NO;
        navBarScrollView.showsVerticalScrollIndicator=NO;
        
        [self.customNavigationBar addSubview:navBarScrollView];
        
        _navBarScrollView=navBarScrollView;
    }
    return _navBarScrollView;
}



#pragma mark - 准备navigationBar视图
-(void)prepareNavigationBar
{
    
    [self.view addSubview:self.customNavigationBar];
    
    //插入左右两个按钮
    UIButton * leftButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setImage:[[UIImage imageNamed:@"icon_home_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, LeftOrRightBtnWidthOrHeight, LeftOrRightBtnWidthOrHeight);
    [_customNavigationBar addSubview:leftButton];
    
    UIButton * rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setImage:[[UIImage imageNamed:@"icon_class_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(ScreenWidth-LeftOrRightBtnWidthOrHeight, 0, LeftOrRightBtnWidthOrHeight, LeftOrRightBtnWidthOrHeight);
    
    //右边按钮添加点击事件（点击之后将chooseClassesView提到最前）
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_customNavigationBar addSubview:rightButton];
    
    [self prepareNavBarScrollView];
   
}

//创建navigationBar中的scrollView
//－－提出来的目的是为了刷新数据的时候，不那么消耗内存（不用所有的navigationBar都刷新）
-(void)prepareNavBarScrollView
{
   
    //先将scrollView中的子控件全部删除（因为刷新还会调用）
    for (id obj in self.navBarScrollView.subviews) {
        [obj removeFromSuperview];
    }
    
    //重新设置contentSize
    self.navBarScrollView.contentSize=CGSizeMake(NavBarButtonWidth*self.myClassesArray.count, NavBarButtonHeight);
    
    
    //2.添加button
    for (int i=0;i<(int)self.myClassesArray.count;i++) {
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(i*NavBarButtonWidth, NavBarButtonSpacing, NavBarButtonWidth, NavBarButtonHeight);
        
        NSString * myClassesString = self.myClassesArray[i];
        [button setTitle:myClassesString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:245.0/255 green:29.0/255 blue:128.0/255 alpha:1] forState:UIControlStateNormal];
        
        //添加点击事件
        [button addTarget:self action:@selector(navBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navBarScrollView addSubview:button];
    }
    
    //添加那条红色的line
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, NavBarButtonSpacing+NavBarButtonHeight, NavBarLineWidth, NavBarLineHeight)];
    _lineView.center=CGPointMake(NavBarButtonWidth/2, _lineView.center.y);
    _lineView.backgroundColor=[UIColor colorWithRed:245.0/255 green:29.0/255 blue:128.0/255 alpha:1];
    [self.navBarScrollView addSubview:_lineView];

}


//navigationBar上的button的点击事件
-(void)navBarButtonClick:(UIButton *)button
{
    //改变lineView的center值
    _lineView.center=CGPointMake(button.center.x, _lineView.center.y);
}
                        




//“展开分类”按钮点击事件
-(void)rightBtnClick
{
    [self.view bringSubviewToFront:self.chooseClassesView];
}


#pragma mark - ChooseClassesViewDelegate代理方法
-(void)updateNavScrollView
{
    //重新更新数据
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    self.myClassesArray=[userDefaults objectForKey:@"MyClassesArray"];
    [self prepareNavBarScrollView];
}






@end

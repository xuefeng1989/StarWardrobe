//
//  ChooseClassesView.m
//  StarWardrobe
//
//  Created by qianfeng on 15-8-20.
//  Copyright (c) 2015年 SJ. All rights reserved.
//


#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏高
#define NavigationBarHeight 44.0f   //navigationBar的高
#define TitleLabelWidth 150.0f  //navigationBar中的标题label的宽度
#define RightButtonWightOrHeight 44.0f  //右边按钮的宽高
#define HeaderViewHeight 30.0f  //头视图的高度
#define SpacingWidth 15.0f  //不同button之间的间距
#define ColumnNum 4 //列数
#define ButtonHeight 30.0f //行高

#define EditBtnWidth 50.0f  //编辑按钮的宽


#import "ChooseClassesView.h"

@interface ChooseClassesView ()
{
    //三个视图
    UIView * _allClassesView;
    UIView * _myClassesView;
    UIView * _customNavigationBar;
    
    UIButton * _editButton; //编辑按钮
}

//“我的类别”数组
@property (nonatomic ,strong)NSMutableArray * myClassesArray;

//存放“其他类别”的数组
@property (nonatomic ,strong)NSMutableArray * otherClassesArray;

//存放“我的类别”的button的数组（为了方便选中）
@property (nonatomic ,strong)NSMutableArray * myClassesViewButtonsArray;


@end

@implementation ChooseClassesView


#pragma mark -懒加载方法
//懒加载创建“所有分类”数组
-(NSArray *)allClassesArray
{
    if (!_allClassesArray) {
        //所有分类是固定的
        _allClassesArray=[[NSArray alloc]initWithObjects:@"复古",@"轻熟",@"OL",@"清新",@"混搭",@"甜美",@"街头",@"闺蜜",@"休闲",@"摩登",@"逛街",@"约会",@"排队",@"运动",@"出游",@"典礼",@"高挑",@"娇小",@"热门",@"欧美",@"日韩",@"型男",@"本土",@"丰满", nil];
    }
    return _allClassesArray;
}

//懒加载“我的分类”数组
-(NSMutableArray *)myClassesArray
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


//懒加载“其他分类”数组
//创建用来保存“其他分类”的数组空间
-(NSMutableArray *)otherClassesArray
{
    if (!_otherClassesArray) {
        _otherClassesArray=[[NSMutableArray alloc]init];
    }
    return _otherClassesArray;
}


//“我的类别”button数组
-(NSMutableArray *)myClassesViewButtonsArray
{
    if (!_myClassesViewButtonsArray) {
        _myClassesViewButtonsArray=[[NSMutableArray alloc]init];
    }
    return _myClassesViewButtonsArray;
}




#pragma mark - initWithFrame方法

//在init方法中创建一些子视图
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        
        self.backgroundColor=[UIColor whiteColor];
        
        [self prepareNavigatioinBar];
        [self prepareMyClassesView];
        [self prepareOtherClassesView];
        
    }
    return self;
}


//创建头视图（navigationBar）
-(void)prepareNavigatioinBar
{
    _customNavigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, NavigationBarHeight)];
    
    //--------color-------------
//    navigationBar.backgroundColor=[UIColor cyanColor];
    
    //titleLabel创建(放到中间)
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-TitleLabelWidth/2, 0, TitleLabelWidth, NavigationBarHeight)];
    
    //--------color-------------
//    titleLabel.backgroundColor=[UIColor greenColor];
    
    titleLabel.text=@"频道定制";
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [_customNavigationBar addSubview:titleLabel];
    
    
    //rightButton的创建(点击销毁)
    UIButton * rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame=CGRectMake(ScreenWidth-RightButtonWightOrHeight, 0, RightButtonWightOrHeight, RightButtonWightOrHeight);
    [rightButton setImage:[[UIImage imageNamed:@"icon_class_swallow"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    //给右边按钮添加点击事件（点击后销毁）
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_customNavigationBar addSubview:rightButton];
    
    [self addSubview:_customNavigationBar];
    
}

//点击按钮销毁视图（并将“我的分类”保存进userDefualt中）
-(void)rightBtnClick
{
    //1.保存在userDefualt中
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.myClassesArray forKey:@"MyClassesArray"];
    //同步
    [userDefaults synchronize];
    
    //2.调用代理方法，更新navigationBar上scrollView的数据(可能添加或者删除了分类)
    [self.delegate updateNavScrollView];
    
    //3.将视图移除
    [self removeFromSuperview];
    
    
   
}


#pragma mark - “所有分类”

//创建其他分类视图（通过传入的数据源）
-(void)prepareOtherClassesView
{
    //创建头视图
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeaderViewHeight)];
    
    //---------------color------------------------------
    headerView.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    //创建在headerView上的lable显示文字
    UILabel * headerLabel=[[UILabel alloc]initWithFrame:headerView.bounds];
    headerLabel.text=@"   点击添加分类";
    headerLabel.font=[UIFont systemFontOfSize:15];
    [headerView addSubview:headerLabel];
    
    
    //首先将数组中的全部数据移除
    [self.otherClassesArray removeAllObjects];
    
    
    //获取在“所有分类”中除了“我的分类”以外的其他分类
    // 如果和“我的分类”中相同不同就添加到“其他分类数组”
    int count;
    for (NSString * classString in self.allClassesArray) {
        count=1;
        for (NSString * myClassString in self.myClassesArray) {
            if ([classString isEqualToString:myClassString]) {
                count++;
            }
        }
        if (count==1) {
            [self.otherClassesArray addObject:classString];
        }
    }
    
    
    //计算行数／button的宽，
    CGFloat buttonWidth=(ScreenWidth-(ColumnNum+1)*SpacingWidth)/ColumnNum;
    
    int rowNum=((int)self.otherClassesArray.count)/ColumnNum;
    if(((int)self.otherClassesArray.count)%ColumnNum!=0){
        rowNum++;
    }
    
    //创建布局整个“所有分类”的视图
    _allClassesView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_myClassesView.frame), ScreenWidth, HeaderViewHeight+(ButtonHeight+SpacingWidth)*rowNum+SpacingWidth)];
    [self addSubview:_allClassesView];
    
   
    //放button的scrollView
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, ScreenWidth, (ButtonHeight+SpacingWidth)*rowNum+SpacingWidth)];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    
    //因为如果contentSize和scrollView的大小一样的话，无法产生可以滚动的效果
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height+1);
    [_allClassesView addSubview:scrollView];
    
    
    //button布局
    for (int num=0; num<(int)self.otherClassesArray.count; num++) {
        
        int i=num/ColumnNum;    //行号
        int j=num%ColumnNum;    //列号
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[self.otherClassesArray objectAtIndex:num] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        
        //---------------color------------------------------
//        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.layer.cornerRadius=5;
        button.layer.masksToBounds=YES;
        button.layer.borderWidth=1;
        button.layer.borderColor=[[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1]CGColor];
        
        
        //计算frame
        button.frame=CGRectMake(j*(SpacingWidth+buttonWidth)+SpacingWidth, i*(SpacingWidth+ButtonHeight)+SpacingWidth, buttonWidth, ButtonHeight);
        
        //allClassesView中的button的tag是从1000开始
        button.tag=1000+i;
        
        //点击事件（点击后添加到我的分类中）
        [button addTarget:self action:@selector(allClassesViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [scrollView addSubview:button];
    }
    
    [_allClassesView addSubview:headerView];
    
    [self addSubview:_allClassesView];
    
}


//点击事件（点击就将对应的分类添加到“我的分类”中）
-(void)allClassesViewBtnClick:(UIButton *)button
{
    //获得在button中的text
    NSString * classString=button.titleLabel.text;
    [self.myClassesArray addObject:classString];
    
    //先将所有视图先移除,后刷新
    [_myClassesView removeFromSuperview];
    [_allClassesView removeFromSuperview];
    
    
    //刷新数据
    [self prepareMyClassesView];
    [self prepareOtherClassesView];
}



#pragma mark - “我的分类”

//准备“我的分类视图”
-(void)prepareMyClassesView
{
    //创建头视图
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeaderViewHeight)];
    
    //---------------color------------------------------
    headerView.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    //创建在headerView上的lable显示文字
    UILabel * headerLabel=[[UILabel alloc]initWithFrame:headerView.bounds];
    headerLabel.text=@"   我的分类";
    headerLabel.font=[UIFont systemFontOfSize:15];
    [headerView addSubview:headerLabel];
    
    //“编辑”按钮
    _editButton =[UIButton buttonWithType:UIButtonTypeSystem];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_editButton setTitle:@"完成" forState:UIControlStateSelected];
    
    //----------------color---------------------
    [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    _editButton.frame=CGRectMake(ScreenWidth-EditBtnWidth, 0, EditBtnWidth, HeaderViewHeight);
    
    //添加点击事件
    [_editButton addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:_editButton];
    
    
    //计算行数／button的宽，
    CGFloat buttonWidth=(ScreenWidth-(ColumnNum+1)*SpacingWidth)/ColumnNum;
    
    int rowNum=((int)self.myClassesArray.count)/ColumnNum;
    if(((int)self.myClassesArray.count)%ColumnNum!=0){
        rowNum++;
    }
    
    //创建布局整个“所有分类”的视图
    _myClassesView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_customNavigationBar.frame), ScreenWidth, HeaderViewHeight+(ButtonHeight+SpacingWidth)*rowNum+SpacingWidth)];
    [self addSubview:_myClassesView];
    
    
    //放button的scrollView
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, ScreenWidth, (ButtonHeight+SpacingWidth)*rowNum+SpacingWidth)];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    
    //因为如果contentSize和scrollView的大小一样的话，无法产生可以滚动的效果
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height+1);
    [_myClassesView addSubview:scrollView];
    
    
    //先清空存放button的数组，后存放
    [self.myClassesViewButtonsArray removeAllObjects];
    
    
    //button布局
    for (int num=0; num<(int)self.myClassesArray.count; num++) {
        
        int i=num/ColumnNum;    //行号
        int j=num%ColumnNum;    //列号
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[self.myClassesArray objectAtIndex:num] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        
        //---------------color------------------------------
        //        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.layer.cornerRadius=5;
        button.layer.masksToBounds=YES;
        button.layer.borderWidth=1;
        button.layer.borderColor=[[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1]CGColor];
        
        
        //计算frame
        button.frame=CGRectMake(j*(SpacingWidth+buttonWidth)+SpacingWidth, i*(SpacingWidth+ButtonHeight)+SpacingWidth, buttonWidth, ButtonHeight);
        
        //myClassesView中的button的tag是从2000开始
        button.tag=2000+i;
        
        //点击事件（在选中状态下和非选中状态下的点击事件是不同的！！）
        [button addTarget:self action:@selector(myClassesViewBtnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        [UIView animateWithDuration:2 animations:^{
            [scrollView addSubview:button];
        }];
        
        
        //将除了第一个“最新”类别以外的类别，存放进数组中
        if (num!=0) {
            [self.myClassesViewButtonsArray addObject:button];

        }
    }
    
    [_myClassesView addSubview:headerView];
    
    [self addSubview:_myClassesView];

}


//“编辑”按钮点击事件（点击后，隐藏“全部分类”view，删除“我的分类”中的button）
-(void)editBtnClick
{
    //隐藏“全部分类”view
    _allClassesView.hidden=!_allClassesView.hidden;
    
    //改变editButton的选中状态
    _editButton.selected=!_editButton.selected;
    
    //更改“我的分类”button的选中状态
    for (UIButton * button in self.myClassesViewButtonsArray) {
        button.selected=!button.selected;
    }
    
}

//“我的分类”button的点击事件
-(void)myClassesViewBtnClick:(UIButton *)button
{
    //当button为选中状态下时，可以删除
    if (button.selected) {
        NSString * myClassString=button.titleLabel.text;
        [_myClassesArray removeObject:myClassString];
    
        //直接将点击的button从父视图上移除
//        [button removeFromSuperview];
        
        
        //更新数据
        //1.先删除
        [_myClassesView removeFromSuperview];
        [_allClassesView removeFromSuperview];
        
        //2.后刷新
        [self prepareMyClassesView];
        [self prepareOtherClassesView];
        
        [self editBtnClick];
        
        
    }
    
    //当不是选中状态下，可以切换到首页视图对应的分类页面
    else if (!button.selected)
    {
        
    }
}






@end

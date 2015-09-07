//
//  SimpleTabBarController.m
//  CustomTabBarController
//
//  Created by qianfeng on 15-8-13.
//  Copyright (c) 2015年 SJ. All rights reserved.
//

#define GestureRangeWidth 100.0f    //手势有效的范围宽度（从0-100）

#define PanRangeWidth ([UIScreen mainScreen].bounds.size.width-100.0)   //侧滑的最大区域


#import "SimpleTabBarController.h"
#import "SimpleUIButton.h"

@interface SimpleTabBarController ()

//用来存储button的数组
@property (nonatomic ,strong)NSMutableArray * itemsArray;

/*因为会添加到tabbar中成为子视图，所以不用再通过这个数组进行强引用*/
//用来存储所有buttons，防止button丢失
//@property (nonatomic ,strong)NSMutableArray * buttonsArray;

//记录选中的button是那个（为了设置button的选中状态）
@property (nonatomic ,weak)SimpleUIButton * selectedButton;

//存储最开始的center位置
//@property (nonatomic ,assign)CGPoint startCenter;


@end

@implementation SimpleTabBarController


//通过懒加载创建存储item(存储创建button需要的信息)的数组
-(NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray=[[NSMutableArray alloc]init];
    }
    return _itemsArray;
}

//通过懒加载创建存储buttons的数组（为了防止指向button的指针丢失）
//-(NSMutableArray *)buttonsArray
//{
//    if (!_buttonsArray) {
//        _buttonsArray=[[NSMutableArray alloc]init];
//    }
//    return _buttonsArray;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    //获取最开始的center位置
    self.startCenter=self.view.center;
    
    //给整个tabbarController视图添加手势（侧滑）
    UIPanGestureRecognizer * panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
     */
}


/*
#pragma mark - 手势方法

-(void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    //记录起始点（只有在一定范围内，才会侧滑）
    CGPoint firstPoint=[panGesture locationInView:self.view];
    
    //在范围之后（左边0-100），才会侧滑
    if (firstPoint.x<GestureRangeWidth) {
        
        //记录偏移量
        CGPoint offset=[panGesture translationInView:self.view];
        
        [UIView animateWithDuration:1 animations:^{
            
            self.view.center=CGPointMake(self.view.center.x+offset.x, self.startCenter.y);
            
            //因为偏移量会叠加，所以要重置
            [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            
            NSLog(@"------pan-------");
        }];
        
        //当滑动的距离超过了滑动范围一半的时候，就会滑过去，否则返回侧滑之前的状态
        if (self.view.center.x>GestureRangeWidth/2+self.startCenter.x) {
            
            [UIView animateWithDuration:1 animations:^{
            
                self.view.center=CGPointMake(self.startCenter.x+PanRangeWidth, self.startCenter.y);
                
                //因为偏移量会叠加，所以要重置
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                NSLog(@"------pan2-------");
            }];

        }
        
        //当滑动的距离超过了滑动范围一半的时候，就会滑过去，否则返回侧滑之前的状态
//        else if (self.view.center.x<GestureRangeWidth/2+self.startCenter.x) {
//            
//            [UIView animateWithDuration:1 animations:^{
//                
//                self.view.center=CGPointMake(self.startCenter.x, self.startCenter.y);
//                
//                //因为偏移量会叠加，所以要重置
//                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
//                
//                NSLog(@"------pan3-------");
//            }];
//            
//        }
        
    }
    
    
    
    
}

 */




#pragma mark - viewWillLayoutSubviews(buttons布局)
-(void)viewWillLayoutSubviews
{
    //调用布局buttons的方法
    [self layoutButtons];


    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加视图控制器
-(void)addViewController:(UIViewController *)viewController withTitle:(NSString *)title withImage:(UIImage *)image withSelectedImage:(UIImage *)selectedImage
{
    //创建item模型，用来创建button（遮盖住相应的item）
    UITabBarItem * item=[[UITabBarItem alloc]init];
    item.title=title;
    item.image=image;
    item.selectedImage=selectedImage;
    
    [self.itemsArray addObject:item];
    
    //添加视图控制器（通过系统的就可以，没必要自己再去创建一个数组记录这些视图控制器）
    [self addChildViewController:viewController];
    
}

#pragma mark - layoutButtons方法
//布局button（遮盖住item）
-(void)layoutButtons
{
    //button的个数＝item的个数＝viewController的个数
    int buttonsCount=(int)self.itemsArray.count;
    
    for(int i=0; i<buttonsCount; i++) {
        SimpleUIButton * button=[[SimpleUIButton alloc]init];
        //因为所有的tag值默认是0，所以让tag值从1开始
        button.tag=i+1;
        
        button.item=self.itemsArray[i];
        
        //------------------------------------------
        button.backgroundColor=[UIColor whiteColor];
        
        //设置button的frame
        CGFloat buttonW=self.tabBar.bounds.size.width/buttonsCount;
        CGFloat buttonH=self.tabBar.bounds.size.height;
        CGFloat buttonX=i*buttonW;
        CGFloat buttonY=0;
        
        button.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //给button添加监听事件(切换视图／按钮的选中状态)
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //第一个默认选中
        if (i==0) {
            self.selectedButton=button;
            self.selectedButton.selected=YES;
        }
        
        //将button添加到tabbar上（遮盖掉UITabBarItem对应的UITabBarButton）
        [self.tabBar addSubview:button];
    }
}


//button的监听事件
-(void)buttonClick:(SimpleUIButton *)button
{
    //切换到对应的视图
    self.selectedIndex=button.tag-1;
    
    //设置按钮的选中状态
    self.selectedButton.selected=NO;
    self.selectedButton=button;
    self.selectedButton.selected=YES;
    
}




@end

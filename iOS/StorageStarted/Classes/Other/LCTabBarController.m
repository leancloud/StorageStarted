//
//  ProductListViewController.h
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCNavigationController.h"
#import "ProductListViewController.h"
#import "EditProductViewController.h"
#import "PersonalCenterViewController.h"
@interface LCTabBarController ()

@end

@implementation LCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
}

-(void)setupChildViewControllers{
    
   [self setupOneChildController:[[LCNavigationController alloc]initWithRootViewController:[[ProductListViewController alloc] init]]title:@"商品列表" image:@"home"
                  selectedImage:nil];
    [self setupOneChildController:[[LCNavigationController alloc]initWithRootViewController:[[EditProductViewController alloc] init] ]title:@"发布新商品" image:@"edit"
                    selectedImage:nil];

    [self setupOneChildController:[[LCNavigationController alloc]initWithRootViewController:[[PersonalCenterViewController alloc] initWithNibName: @"PersonalCenterViewController" bundle:nil]]title:@"我的发布" image:@"personal"
                        selectedImage:nil];

}
- (void)setupOneChildController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    //如果没有传图片值,判断一下
    if(image.length){
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}

-(void)setupItemTitleTextAttributes{
    //UITabBarItem文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    //文字正常
    NSMutableDictionary *normaAttrs = [NSMutableDictionary dictionary];
    normaAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normaAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes: normaAttrs forState:UIControlStateNormal];
    
    //文字选中
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes: selectedAttrs forState:UIControlStateSelected];
}
@end

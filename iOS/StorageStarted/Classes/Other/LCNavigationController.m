//
//  ProductListViewController.h
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//
#import "LCNavigationController.h"

@interface LCNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;

    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

/**
 *  重写push方法:拦截所有push进来的自控制器
 *
 *  @param viewController 刚刚push进来的自控制器

 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.childViewControllers.count>0){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal
         ];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

        [backButton sizeToFit];
        
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside ];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        //隐藏底部工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}
- (void)back{
    
    [self popViewControllerAnimated:YES];
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}

@end

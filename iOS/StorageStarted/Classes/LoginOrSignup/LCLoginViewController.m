//
//  LCLoginViewController.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "LCLoginViewController.h"
#import "LCTabBarController.h"
#import <LCUser.h>
@interface LCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}
// LeanCloud - 登录 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash964666
- (IBAction)LoginBtnClick:(id)sender {
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (username && password) {
        [LCUser logInWithUsernameInBackground:username password:password block:^(LCUser *user, NSError *error){
           if (user) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[LCTabBarController alloc]init];
            } else {
            NSLog(@"登录失败：%@",error.localizedFailureReason);
            }
        }];
    }
}

// LeanCloud - 注册 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash885156
- (IBAction)SignUpBtnClick:(id)sender {
    
    LCUser *user = [LCUser user];
    user.username = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功直接登录
            [LCUser logInWithUsernameInBackground:self.userNameTextField.text password:self.passwordTextField.text block:^(LCUser *user, NSError *error){
                if (user) {
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[LCTabBarController alloc]init];
                } else {
                    NSLog(@"登录失败：%@",error.localizedFailureReason);
                }
            }];
        }else if(error.code == 202){
            //注册失败的原因可能有多种，常见的是用户名已经存在。
            NSLog(@"注册失败，用户名已经存在");
        }else{
            NSLog(@"注册失败：%@",error.localizedFailureReason);
        }
    }];
}

@end


//
//  SignUpViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "SignUpViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)signUpButtonPressed:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"SignUpView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"SignUpView"];
}

- (void)setupUI {
  self.title = @"注册";
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    if (username && password && email) {
        // LeanCloud - 注册
        // https://leancloud.cn/docs/leanstorage_guide-ios.html#用户名和密码注册
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
            } else {
                NSLog(@"注册失败 %@", error);
            }
        }];
    }
}
@end

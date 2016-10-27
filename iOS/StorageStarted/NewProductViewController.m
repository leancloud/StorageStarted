//
//  NewProductViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "NewProductViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface NewProductViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)releaseButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;


@end

@implementation NewProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"PublishView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"PublishView"];
}

- (void) setupUI {
    self.imageView.image = self.selectedImage;
    self.descriptionTextView.delegate = self;
    [self.indicatorView setHidden:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入描述"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入描述";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}


#pragma mark - IBActions
- (IBAction)releaseButtonPressed:(id)sender {
    // UI
    [self.indicatorView startAnimating];
    [self.indicatorView setHidden:NO];
    
    NSString *title = self.titleTextField.text;
    NSNumber *price = [NSNumber numberWithInt:[self.priceTextField.text intValue]];
    NSString *description = self.descriptionTextView.text;
    
    // 保存商品信息
    // LeanCloud - 构建图片
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#从数据流构建文件
    NSData *data = UIImagePNGRepresentation(self.selectedImage);
    AVFile *file = [AVFile fileWithData:data];
    // LeanCloud - 获取当前用户
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#当前用户
    AVUser *currentUser = [AVUser currentUser];
    
    // LeanCloud - 保存对象
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#对象
    AVObject *product = [AVObject objectWithClassName:@"Product"];
    [product setObject:title forKey:@"title"];
    [product setObject:price forKey:@"price"];
    
    // owner 字段为 Pointer 类型，指向 _User 表
    [product setObject:currentUser forKey:@"owner"];
    // image 字段为 File 类型
    [product setObject:file forKey:@"image"];
    [product setObject:description forKey:@"description"];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.indicatorView setHidden:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"保存新物品出错 %@", error);
        }
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

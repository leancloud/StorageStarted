//
//  NewGoodsViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "NewGoodsViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface NewGoodsViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)releaseButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;


@end

@implementation NewGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) initUI {
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
    
    // 保存商品信息
    // LeanCloud - 上传图片
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#文件上传
    NSData *data = UIImagePNGRepresentation(self.selectedImage);
    AVFile *file = [AVFile fileWithData:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString *title = self.titleTextField.text;
            NSNumber *price = [NSNumber numberWithInt:[self.priceTextField.text intValue]];
            NSString *description = self.descriptionTextView.text;
            
            // LeanCloud - 获取当前用户
            // https://leancloud.cn/docs/leanstorage_guide-ios.html#当前用户
            AVUser *currentUser = [AVUser currentUser];
            
            // LeanCloud - 保存对象
            // https://leancloud.cn/docs/leanstorage_guide-ios.html#对象
            AVObject *goods = [AVObject objectWithClassName:@"Goods"];
            [goods setObject:title forKey:@"title"];
            [goods setObject:price forKey:@"price"];
            [goods setObject:file.url forKey:@"imageUrl"];
            // owner 字段为 Pointer 类型，指向 _User 表
            [goods setObject:currentUser forKey:@"owner"];
            [goods setObject:description forKey:@"description"];
            [goods saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.indicatorView setHidden:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"保存新物品出错 %@", error);
                }
            }];
            
        } else {
            NSLog(@"上传图片出错 %@", error);
        }
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

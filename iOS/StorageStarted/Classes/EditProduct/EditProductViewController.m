//
//  EditProductViewController.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "EditProductViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface EditProductViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *productitleText;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;
@end

@implementation EditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布新商品";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"EditProduct"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"EditProduct"];
}
#pragma mark -  Button Callbacks

- (IBAction)openAlbumBtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)takePhotoBtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypeCamera];
}
/*
 * LeanCloud - 保存对象 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash632314851
*/
- (IBAction)publishBtn:(id)sender {
    NSString *title = self.productitleText.text;
    NSNumber *price = @(self.priceLabel.text.intValue);
    AVObject *product = [AVObject objectWithClassName:@"Product"];
    [product setObject:title forKey:@"title"];
    [product setObject:price forKey:@"price"];

    // owner 字段为 Pointer 类型，指向 _User 表
    AVUser *currentUser = [AVUser currentUser];
    [product setObject:currentUser forKey:@"owner"];
   
    AVFile *file = [AVFile fileWithData:self.imageData];
    [product setObject:file forKey:@"image"];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"保存新物品成功");
            [self alertMessage:@"保存新商品成功"];

        } else {
            NSLog(@"保存新物品出错 %@", error.localizedFailureReason);
        }
    }];
}
#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.productImageView.image = image;
    NSData * imageData;
    if (UIImagePNGRepresentation(image)) {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    self.imageData = imageData;
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 选择图片
-(void)selectImageWithPickertype:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = sourceType;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else{
        [self alertMessage:@"图片库不可用或当前设备没有摄像头"];
    }
}
#pragma mark -  Private Methods
-(void)alertMessage:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
@end

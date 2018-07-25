//
//  EditProductViewController.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "UpdateMyProductController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UpdateMyProductController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *productitleText;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;
@end

@implementation UpdateMyProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改我的商品";
    self.productitleText.text = self.product.title;
    self.priceLabel.text = self.product.price;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.product.productImageUrl]
                             placeholderImage:[UIImage imageNamed:@"downloadFailed"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"UpdateMyProduct"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"UpdateMyProduct"];
}
#pragma mark -  Button Callbacks

- (IBAction)openAlbumBtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)takePhotoBtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypeCamera];
}

/*
 * LeanCloud - 更新对象
 * https://leancloud.cn/docs/leanstorage_guide-objc.html#hash810954180
*/
- (IBAction)publishBtn:(id)sender {
    
    NSString *title = self.productitleText.text;
    NSNumber *price = @(self.priceLabel.text.intValue);
    //根据 objectId 更新对象
    AVObject *product =[AVObject objectWithClassName:@"Product" objectId:self.product.objectId];
    
    [product setObject:title forKey:@"title"];
    [product setObject:price forKey:@"price"];
    if (self.imageData) {
        AVFile *file = [AVFile fileWithData:self.imageData];
        [product setObject:file forKey:@"image"];
    }
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"更新成功");
            [self .navigationController popToRootViewControllerAnimated: YES]; 
        } else {
            NSLog(@"更新出错 %@", error.localizedFailureReason);
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"图片库不可用或当前设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
@end

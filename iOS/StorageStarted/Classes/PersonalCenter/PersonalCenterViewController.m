//
//  PersonalCenterViewController.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MyProductCell.h"
#import "Product.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UpdateMyProductController.h"
#import "LCLoginViewController.h"

#import <LCUser.h>
#import <LCFile.h>
#import <LCQuery.h>

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UILabel *noProductLabel;

@property (nonatomic,strong) NSMutableArray <Product *> *myProductArr;
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.productTableView.delegate =self;
    self.productTableView.dataSource =self;
    [self setUserInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //查询我发布的产品
    [self queryProduct];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}
//退出登录
- (IBAction)logOutBtnClick:(id)sender {

    [LCUser logOut];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LCLoginViewController  alloc]init];
}
//更换头像
- (IBAction)changeAvatarBtnClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else{
        [self alertMessage:@"图片库不可用"];
    }
}
#pragma mark -  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myProductArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyProductCell * cell = [MyProductCell cellWithTableView:tableView];
    cell.product = self.myProductArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateMyProductController *updateVc = [[UpdateMyProductController alloc]init];
    updateVc.product =self.myProductArr[indexPath.row];
    [self.navigationController pushViewController:updateVc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.userAvatarImage.image =image;
    NSData * imageData = UIImagePNGRepresentation(image);
    LCUser *currentuser = [LCUser currentUser];
    LCFile *avatarFile = [LCFile fileWithData:imageData];
    [currentuser setObject:avatarFile forKey:@"avatar"];
    [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self alertMessage:@"头像上传成功"];
    }];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  Life Cycle
-(void)queryProduct{
    // 查询我发布过的产品
    LCUser *currentUser =[LCUser currentUser];
    
    LCQuery *query = [LCQuery queryWithClassName:@"Product"];
    [query orderByDescending:@"updateAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"owner"];
    // image 为 File
    [query includeKey:@"image"];
    [query whereKey:@"owner" equalTo:currentUser];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.myProductArr removeAllObjects];
            for (NSDictionary *object in objects) {
                Product * product = [Product initWithObject:object];
                [self.myProductArr addObject:product];
                self.noProductLabel.hidden = (objects.count != 0);
                
            }
        }
        [self.productTableView reloadData];
    }];
}
-(void)setUserInfo{
    LCUser *currentUser =[LCUser currentUser];
    self.nameLabel.text = currentUser.username;
    LCFile * avatarFile = [currentUser objectForKey:@"avatar"];
    if (avatarFile) {
        [self.userAvatarImage sd_setImageWithURL:[NSURL URLWithString:avatarFile.url]
                                placeholderImage:[UIImage imageNamed:@"not_logged_in"]];
    }
}
-(void)alertMessage:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(NSMutableArray<Product *> *)myProductArr{
    if (!_myProductArr) {
        _myProductArr = [NSMutableArray array];
    }
    return _myProductArr;
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
@end


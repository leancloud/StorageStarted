//
//  GoodsListTableViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "GoodsListTableViewController.h"
#import "NewGoodsViewController.h"
#import "GoodsDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "GoodsTableViewCell.h"

@interface GoodsListTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *goods;
- (IBAction)releaseButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end

@implementation GoodsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.goods count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    AVObject *goods = self.goods[indexPath.row];
    AVUser *owner =[goods objectForKey:@"owner"];
    
    cell.nickname.text = owner.username;
    cell.price.text = [NSString stringWithFormat:@"¥ %@",[goods objectForKey:@"price"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.releaseDate.text = [dateFormatter stringFromDate:goods.createdAt];
    
    cell.goodsTitle.text = [goods objectForKey:@"title"];
    
    // LeanCloud - 获取图片缩略图
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#图像缩略图
    NSString *imageUrl = [goods objectForKey:@"imageUrl"];
    AVFile *file = [AVFile fileWithURL:imageUrl];
    [file getThumbnail:NO width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        cell.goodsImage.image = image;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVObject *selectedGoods = self.goods[indexPath.row];
    [self performSegueWithIdentifier:@"toDetailView" sender:selectedGoods];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"toRelaseView"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        NewGoodsViewController *vc = (NewGoodsViewController *) [navigationController topViewController];
        UIImage *image = (UIImage *) sender;
        vc.selectedImage = image;
    } else if ([[segue identifier] isEqualToString: @"toDetailView"]) {
        GoodsDetailViewController *vc = [segue destinationViewController];
        AVObject *goods = (AVObject *) sender;
        vc.goods = goods;
    }
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"toRelaseView" sender:selectedImage];
}

#pragma mark - custom methods
- (void) initData {
    // LeanCloud - 查询 - 获取商品列表
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#查询
    AVQuery *query = [AVQuery queryWithClassName:@"Goods"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.goods = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - IBActions
- (IBAction)releaseButtonPressed:(UIBarButtonItem *)sender {
    // 选择照片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];


}

- (IBAction)logoutButtonPressed:(id)sender {
    // LeanCloud - 退出登录
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#登出
    [AVUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

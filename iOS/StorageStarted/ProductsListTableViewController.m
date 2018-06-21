//
//  ProductsListTableViewController.m
//  
//
//  Created by cuiyiran on 16/9/18.
//
//

#import "ProductsListTableViewController.h"
#import "NewProductViewController.h"
#import "ProductDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ProductTableViewCell.h"

@interface ProductsListTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *products;
- (IBAction)releaseButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end

@implementation ProductsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupData];
    [AVAnalytics beginLogPageView:@"MainView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"MainView"];
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
    return [self.products count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    AVObject *product = self.products[indexPath.row];
    AVUser *owner =[product objectForKey:@"owner"];
    
    cell.nickname.text = owner.username;
    cell.price.text = [NSString stringWithFormat:@"¥ %@",[product objectForKey:@"price"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.releaseDate.text = [dateFormatter stringFromDate:product.createdAt];
    
    cell.productTitle.text = [product objectForKey:@"title"];
    
    // 获取图片 url
    AVFile *file = [product objectForKey:@"image"];
    [file downloadWithCompletionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: filePath]];
        cell.productImage.image = image;
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVObject *selectedProduct = self.products[indexPath.row];
    [self performSegueWithIdentifier:@"toDetailView" sender:selectedProduct];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"toRelaseView"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        NewProductViewController *vc = (NewProductViewController *) [navigationController topViewController];
        UIImage *image = (UIImage *) sender;
        vc.selectedImage = image;
    } else if ([[segue identifier] isEqualToString: @"toDetailView"]) {
        ProductDetailViewController *vc = [segue destinationViewController];
        AVObject *product = (AVObject *) sender;
        vc.product = product;
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
- (void) setupData {
    // LeanCloud - 查询 - 获取商品列表
    // https://leancloud.cn/docs/leanstorage_guide-ios.html#查询
    AVQuery *query = [AVQuery queryWithClassName:@"Product"];
    [query orderByDescending:@"createdAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"owner"];
    // image 为 File
    [query includeKey:@"image"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.products = objects;
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

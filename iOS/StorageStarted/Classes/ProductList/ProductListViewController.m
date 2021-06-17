//
//  ProductListViewController.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "ProductListViewController.h"
#import "Product.h"
#import "ProductListCell.h"
#import <LCQuery.h>
@interface ProductListViewController ()
@property (nonatomic,strong) NSMutableArray <Product *> *productArr;
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LeanCloud";
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.productArr removeAllObjects];
    [self queryProduct];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

#pragma mark -  Private Methods
// LeanCloud - 查询 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash860317
-(void)queryProduct{
    
    LCQuery *query = [LCQuery queryWithClassName:@"Product"];
    [query orderByDescending:@"createdAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"owner"];
    // image 为 File
    [query includeKey:@"image"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (NSDictionary *object in objects) {
                Product * product = [Product initWithObject:object];
                [self.productArr addObject:product];
            }
        }
        [self.tableView reloadData];
        
    }];
    
}
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductListCell * cell = [ProductListCell cellWithTableView:tableView];
    cell.product = self.productArr[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.productArr[indexPath.row].cellHeight;
}
-(NSMutableArray<Product *> *)productArr{
    if (!_productArr) {
        _productArr =[NSMutableArray array];
    }
    return _productArr;
}

@end


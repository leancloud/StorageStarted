//
//  MyProductCell.h
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/24.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@interface MyProductCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) Product  * product;
@end

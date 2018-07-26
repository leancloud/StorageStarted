//
//  ProductListCell.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "ProductListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ProductListCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end

@implementation ProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * ProductListCellID = @"ProductListCell";
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductListCellID];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductListCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;

    return cell;
}

-(void)setProduct:(Product *)product{
    _product = product;
    self.name.text = product.name;
    self.time.text = product.date;
    self.price.text = [NSString stringWithFormat:@"¥ %@",product.price];
    self.title.text = product.title;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:product.avatarUrl]
                            placeholderImage:[UIImage imageNamed:@"not_logged_in"]];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.productImageUrl]
                      placeholderImage:[UIImage imageNamed:@"downloadFailed"]];
}
@end

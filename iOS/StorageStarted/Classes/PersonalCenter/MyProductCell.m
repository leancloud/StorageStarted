//
//  MyProductCell.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/24.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "MyProductCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation MyProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * ProductListCellID = @"MyProductCell";
    MyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductListCellID];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyProductCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setProduct:(Product *)product{
    _product = product;
    self.price.text = self.price.text = [NSString stringWithFormat:@"¥ %@",product.price];
    self.title.text = product.title;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.productImageUrl]
                             placeholderImage:[UIImage imageNamed:@"downloadFailed"]];
}

@end

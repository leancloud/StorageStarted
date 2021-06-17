//
//  Product.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "Product.h"
#import <LCUser.h>
#import <LCFile.h>
@implementation Product
+(instancetype)initWithObject:(NSDictionary *)obj{
    Product * product = [[Product alloc] init];
    product.objectId =[obj objectForKey:@"objectId"];
    LCUser *owner =[obj objectForKey:@"owner"];
    product.name =owner.username;
    LCFile *userAvatar =[owner objectForKey:@"avatar"];
    if (userAvatar) {
        product.avatarUrl = userAvatar.url;
    }
    NSDate *createdAt = [obj objectForKey:@"createdAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    product.date = [dateFormatter stringFromDate:createdAt];
    
    product.price = [NSString stringWithFormat:@"%@",[obj objectForKey:@"price"]];
    product.title = [obj objectForKey:@"title"];
    
    LCFile *file = [obj objectForKey:@"image"];
    product.productImageUrl = file.url;

    return product;
}
#pragma mark -  自适应cell高度
-(CGFloat)cellHeight{
    //如果cell 的高度已经计算过,就直接返回
    if(_cellHeight) return _cellHeight;
    
    // cell高度 = 187+加文字高度
    _cellHeight = 187;
    CGSize labelSize =[self getSizeWithStr:self.title Width:[[UIScreen mainScreen] bounds].size.width-73 Font:11];
    _cellHeight+= labelSize.height;
    return _cellHeight;
}
- (CGSize) getSizeWithStr:(NSString *) str Width:(float)width Font:(float)fontSize
{
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize tempSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attribute
                                        context:nil].size;
    return tempSize;
}
@end


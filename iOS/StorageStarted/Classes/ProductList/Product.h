//
//  Product.h
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/23.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Product : NSObject

+(instancetype)initWithObject:(NSDictionary *)obj;

@property (nonatomic,copy) NSString *objectId;
/** 用户名 */
@property (nonatomic,copy) NSString *name;
/** 用户头像 */
@property (nonatomic,copy) NSString * avatarUrl;
/** 商品发布日期 */
@property (nonatomic,copy) NSString *date;
/** 商品价格 */
@property (nonatomic,copy) NSString *price;
/** 商品描述 */
@property (nonatomic,copy) NSString *title;
/** 商品图片 */
@property (nonatomic,copy) NSString *productImageUrl;
/** cell 的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

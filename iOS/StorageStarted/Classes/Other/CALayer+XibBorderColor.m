//
//  CALayer+XibBorderColor.m
//  StorageStarted
//
//  Created by XiaoXu on 2018/7/24.
//  Copyright © 2018年 cuiyiran. All rights reserved.
//

#import "CALayer+XibBorderColor.h"
@implementation CALayer (XibBorderColor)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}
@end

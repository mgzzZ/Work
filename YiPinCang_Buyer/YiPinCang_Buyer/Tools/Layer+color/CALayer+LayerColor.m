//
//  CALayer+LayerColor.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/20.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end

//
//  CustomTextField.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = [UIColor whiteColor];      //设置光标颜色
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = self.font;
    
    //画出占位符
    CGRect placeholderRect;
    placeholderRect.size.width = rect.size.width;
    placeholderRect.size.height = rect.size.height;
    placeholderRect.origin.x = 0;
    placeholderRect.origin.y = (rect.size.height - self.font.lineHeight) * 0.5;
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    
    //或者
    /*
     CGPoint placeholderPoint = CGPointMake(0, (rect.size.height - self.font.lineHeight) * 0.5);
     [self.placeholder drawAtPoint:placeholderPoint withAttributes:attrs];
     */
}

@end

//
//  UILabel+height.m
//  what2
//
//  Created by Mz on 15/5/15.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import "UILabel+height.h"

@implementation UILabel (height)
- (CGFloat)heightForText:(NSString *)text
{
    return [text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size.height + 4;
}
@end

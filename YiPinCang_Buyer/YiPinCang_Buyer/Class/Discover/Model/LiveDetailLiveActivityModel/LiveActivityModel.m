//
//  LiveActivityModel.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveActivityModel.h"

@implementation LiveActivityModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"strace_contentStr" : @"strace_content",
             
             };
}
@end

//
//  DiscoverDetailModel.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverDetailModel.h"

@implementation DiscoverDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             
             @"p" : @"PModel",
             @"commentlist":@"CommentListModel"
             };
}
+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(MJProperty *__unsafe_unretained)property{
    if ([property.name isEqualToString:@"publisher"]) {
        if (oldValue == nil) return @"";
    }
    return oldValue;
}
@end

//
//  LogisticsinModel.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LogisticsinModel.h"

@implementation LogisticsinModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             
             @"content" : @"LogistcsinContentModel"
             };
}
+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(MJProperty *__unsafe_unretained)property{
    if ([property.name isEqualToString:@"publisher"]) {
        if (oldValue == nil) return @"";
    }
    return oldValue;
}
@end

//
//  NSDictionary+Safety.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "NSDictionary+Safety.h"

@implementation NSDictionary (Safety)
- (id)safe_objectForKey:(id)key
{
    if (!self || !key) {
        return nil;
    }
    if ([[self allKeys] containsObject:key]) {
        return [self objectForKey:key];
    }
    return nil;
}
@end

//
//  OrderDetailModel.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             
             @"goodsinfo" : @"OrderGoodsInfoModel"
             };
}
@end

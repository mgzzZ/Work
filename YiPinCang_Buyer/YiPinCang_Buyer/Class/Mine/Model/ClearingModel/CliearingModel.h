//
//  CliearingModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCarModel.h"
#import "AddAreaModel.h"
#import "InvModel.h"
@class ShoppingCarModel;
@class AddAreaModel;
@class InvModel;
@interface CliearingModel : NSObject
@property (nonatomic,strong)NSMutableArray *store_cart_list;//购物车列表
@property (nonatomic,copy)NSString *store_goods_total;
@property (nonatomic,copy)NSString *freight_list;//运费地区信息加密
@property (nonatomic,copy)NSString *freight;
@property (nonatomic,strong)AddAreaModel *address_info;
@property (nonatomic,copy)NSString *vat_hash;//发票代码
@property (nonatomic,copy)NSString *inv_price;//发票价格
@property (nonatomic,strong)InvModel *inv_info;
@property (nonatomic,copy)NSString *total_price;
@end

//
//  ShoppingCar_goodscommonModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/24.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCar_goodscommonModel : NSObject

@property (nonatomic,copy)NSString *goods_commonid;
@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *store_name;

@property (nonatomic,copy)NSString *goods_name;

@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *goods_uptime;
@property (nonatomic,copy)NSString *store_avatar;
@property (nonatomic,copy)NSString *prestate;//是否预售 1-预售

@property (nonatomic,copy)NSString *goods_salenum;//销量
@property (nonatomic,copy)NSString *total_storage;//库存


@end

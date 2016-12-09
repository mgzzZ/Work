//
//  Order_infoModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@class GoodsModel;

@interface Order_infoModel : NSObject

@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *order_sn;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *payment_time;
@property (nonatomic,copy)NSString *finnshed_time;
@property (nonatomic,copy)NSString *store_name;
@property (nonatomic,copy)NSString *goods_amount;
@property (nonatomic,copy)NSString *shipping_fee;
@property (nonatomic,copy)NSString *order_state;
@property (nonatomic,copy)NSString *shipping_code;
@property (nonatomic,copy)NSString *state_desc;
@property (nonatomic,strong)NSMutableArray *goods;

@end

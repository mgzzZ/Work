//
//  OrderDetailModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderGoodsInfoModel.h"
#import "Reciver_infoModel.h"
@class Reciver_infoModel;
@class OrderGoodsInfoModel;
@interface OrderDetailModel : NSObject

@property (nonatomic,strong)Reciver_infoModel *reciver_info;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *store_name;
@property (nonatomic,copy)NSString *pay_sn;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *shipping_time;//发货时间
@property (nonatomic,copy)NSString *payment_time;
@property (nonatomic,copy)NSString *finnshed_time;
@property (nonatomic,copy)NSString *order_state;
@property (nonatomic,copy)NSString *state_desc;
@property (nonatomic,copy)NSString *invoice_info;
@property (nonatomic,copy)NSString *order_message;
@property (nonatomic,copy)NSString *payment_name;
@property (nonatomic,copy)NSString *goods_amount;
@property (nonatomic,copy)NSString *order_amount;
@property (nonatomic,copy)NSString *shipping_fee;
@property (nonatomic,copy)NSString *remaintime;
@property (nonatomic,copy)NSString *address_lock;
@property (nonatomic,strong)NSMutableArray *goodsinfo;

@end

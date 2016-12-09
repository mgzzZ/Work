//
//  OrderGoodsInfoModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "OrderStoreModel.h"
@class GoodsModel;
@class OrderStoreModel;
@interface OrderGoodsInfoModel : NSObject

@property (nonatomic,strong)NSMutableArray *goods;
@property (nonatomic,strong)OrderStoreModel *store;


@end

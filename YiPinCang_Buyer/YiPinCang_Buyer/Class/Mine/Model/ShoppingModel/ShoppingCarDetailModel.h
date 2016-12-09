//
//  ShoppingCarDetailModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/24.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCar_goodscommonModel.h"

#import "ShoppingImgsModel.h"
@class ShoppingCar_goodscommonModel;

@class ShoppingImgsModel;
@interface ShoppingCarDetailModel : NSObject


@property (nonatomic,strong)ShoppingCar_goodscommonModel  *goodscommon_info;

@property (nonatomic,strong)NSMutableArray  *image;
@end

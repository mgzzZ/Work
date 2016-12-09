//
//  ShoppingCarModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shoppingcar_storeModel.h"
#import "Shoppingcar_dataModel.h"
@class Shoppingcar_storeModel;
@class Shoppingcar_dataModel;
@interface ShoppingCarModel : NSObject
@property (nonatomic,strong)Shoppingcar_storeModel *store;
@property (nonatomic,strong)NSMutableArray *data;
@end

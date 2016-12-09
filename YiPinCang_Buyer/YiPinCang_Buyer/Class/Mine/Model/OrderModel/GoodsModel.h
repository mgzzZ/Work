//
//  GoodsModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *goods_image;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *goods_pay_price;
@property (nonatomic,copy)NSString *goods_num;
@property (nonatomic,copy)NSString *goods_spec;

@end

//
//  Shoppingcar_dataModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shoppingcar_dataModel : NSObject
@property (nonatomic,copy)NSString *cart_id;
@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *goods_num;
@property (nonatomic,copy)NSString *goods_image;
@property (nonatomic,copy)NSString *addtime;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *goods_commonid;
@property (nonatomic,copy)NSString *goods_spec;
@property (nonatomic,copy)NSString *goods_storage;
@property (nonatomic,copy)NSString *remaintime;
@property (nonatomic,assign)BOOL seleted;
@end

//
//  AddAreaVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

typedef void(^BackReload)();
typedef void(^AddBackAreaBlock)(NSString *name,NSString *area,NSString *isDefault,NSString *address_id,NSString *area_id,NSString *city_id);
@interface AddAreaVC : BaseNaviConfigVC

@property (nonatomic,strong)BackReload backreload;

@property (nonatomic,strong)AddBackAreaBlock addBackreload;

@property (nonatomic,strong)NSString *type;//1新建收货地址 2. 更改收货地址

@property (nonatomic,strong)NSString *areaid;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *phone;

@property (nonatomic,strong)NSString *area;

@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *is_default;

@property (copy,nonatomic)NSString *area_id;

@property (copy,nonatomic)NSString *city_id;
@end

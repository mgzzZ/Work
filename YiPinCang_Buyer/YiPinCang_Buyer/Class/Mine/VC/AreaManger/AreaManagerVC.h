//
//  AreaManagerVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

typedef void(^BackAreaBlock)(NSString *name,NSString *area,NSString *isDefault,NSString *address_id,NSString *area_id,NSString *city_id);

@interface AreaManagerVC : BaseNaviConfigVC

@property (nonatomic,copy)BackAreaBlock backArea;

@end

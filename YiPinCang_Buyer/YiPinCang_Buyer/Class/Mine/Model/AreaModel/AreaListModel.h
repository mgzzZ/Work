//
//  AreaListModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaListModel : NSObject


@property (nonatomic,copy)NSString *address_id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *true_name;
@property (nonatomic,copy)NSString *area_id;
@property (nonatomic,copy)NSString *city_id;
@property (nonatomic,copy)NSString *area_info;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *tel_phone;
@property (nonatomic,copy)NSString *mob_phone;
@property (nonatomic,copy)NSString *is_default;
@property (nonatomic,copy)NSString *dlyp_id;
@property (nonatomic,assign)BOOL selede;
@end

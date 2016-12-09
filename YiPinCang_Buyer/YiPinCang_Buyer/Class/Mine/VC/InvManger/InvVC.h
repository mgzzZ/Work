//
//  InvVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

typedef void(^backName)(NSString *str,NSString *inv_id);

@interface InvVC : BaseNaviConfigVC

@property (nonatomic,copy)NSString *str;

@property (nonatomic,copy)backName backname;

@end

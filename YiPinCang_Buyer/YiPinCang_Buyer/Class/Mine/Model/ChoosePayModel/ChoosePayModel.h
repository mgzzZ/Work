//
//  ChoosePayModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/25.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayParamModel.h"
#import "PaylistModel.h"
@class paylistModel;
@class PaylistModel;
@interface ChoosePayModel : NSObject

@property (nonatomic,copy)NSString *remaintime;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,strong)NSMutableArray *paylist;
@property (nonatomic,strong)NSString *pay_sn;

@end



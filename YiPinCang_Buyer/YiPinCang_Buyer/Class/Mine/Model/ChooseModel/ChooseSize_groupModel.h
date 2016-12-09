//
//  ChooseSize_groupModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Choose_spModel.h"
@class Choose_spModel;
@interface ChooseSize_groupModel : NSObject


@property (nonatomic,copy)NSString *sp_name;
@property (nonatomic,copy)NSString *sp_id;
@property (nonatomic,strong)NSMutableArray *data;

@end

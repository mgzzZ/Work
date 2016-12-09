//
//  DiscoverBrandLiskModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandLiskTypeListModel.h"

@class BrandLiskTypeListModel;

@interface DiscoverBrandLiskModel : NSObject


@property (nonatomic,copy)NSString *brand_id;
@property (nonatomic,copy)NSString *brand_name;
@property (nonatomic,copy)NSString *brand_initial;
@property (nonatomic,strong)NSArray *typelist;

@end

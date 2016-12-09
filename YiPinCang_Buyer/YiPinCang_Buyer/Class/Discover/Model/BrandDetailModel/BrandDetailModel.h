//
//  BrandDetailModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandDetailBrandModel.h"
#import "LiveActivityModel.h"

@class LiveActivityModel;

@interface BrandDetailModel : NSObject
@property (nonatomic,strong)BrandDetailBrandModel *brand;
@property (nonatomic,strong)NSMutableArray *list;
@end

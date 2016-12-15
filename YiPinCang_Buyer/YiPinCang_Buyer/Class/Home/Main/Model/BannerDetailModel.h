//
//  BannerDetailModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/13.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerDetailDataModel.h"
@class BannerDetailDataModel;
@interface BannerDetailModel : NSObject


@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)BannerDetailDataModel *data;
@end

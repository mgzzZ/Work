//
//  BannerModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerDetailModel.h"
@class BannerDetailModel;
@interface BannerModel : NSObject

@property (nonatomic, copy) NSString *adv_id;
@property (nonatomic, copy) NSString *adv_title;
@property (nonatomic, copy) NSString *is_allow;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *click_from_type;
@property (nonatomic,strong)BannerDetailModel *param;
@end

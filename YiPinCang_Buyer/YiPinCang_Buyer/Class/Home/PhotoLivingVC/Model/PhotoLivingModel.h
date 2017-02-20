//
//  PhotoLivingModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/2.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoLivingActivityinfoModel;
@class PhotoLivingBrandModel;
@class PhotoLivingStoreinfoModel;
@interface PhotoLivingModel : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) PhotoLivingActivityinfoModel *activityinfo;
@property (nonatomic, strong) PhotoLivingBrandModel *brand;
@property (nonatomic, strong) PhotoLivingStoreinfoModel *storeinfo;

@end

@interface PhotoLivingActivityinfoModel : NSObject
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *hx_lgroupid;
@end

@interface PhotoLivingBrandModel : NSObject
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *brand_store_id;
@property (nonatomic, copy) NSString *store_avatar;
@end

@interface PhotoLivingStoreinfoModel : NSObject
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_avatar;
@property (nonatomic, copy) NSString *store_collect;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *isfollowSeller;
@end

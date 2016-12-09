//
//  HomeTVDetailModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandModel;
@class StoreModel;
@interface HomeTVDetailModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *announcement_id;
@property (nonatomic, copy) NSString *prestate;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *live_state;
@property (nonatomic, copy) NSString *livingshowinitimg;
@property (nonatomic, strong) BrandModel *brand;
@property (nonatomic, strong) StoreModel *store_info;
@property (nonatomic, strong) NSArray *goods_data;

@end

@interface BrandModel : NSObject

@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *brand_initial;
@property (nonatomic, copy) NSString *brand_class;
@property (nonatomic, copy) NSString *brand_pic;
@property (nonatomic, copy) NSString *attentions;

@end

@interface StoreModel : NSObject
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_avatar;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *store_collect;
@property (nonatomic, copy) NSString *live_msg;
@property (nonatomic, copy) NSString *isRss;
@end

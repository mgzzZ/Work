//
//  PreheatingModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreBrandModel, Store_infoModel, Live_infoModel;
@interface PreheatingModel : NSObject

@property (nonatomic, strong) PreBrandModel *brand;
@property (nonatomic, strong) Store_infoModel *store_info;
@property (nonatomic, strong) Live_infoModel *live_info;
@property (nonatomic, strong) NSArray *pre_straces;

@end

@interface PreBrandModel : NSObject
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *brand_initial;
@property (nonatomic, copy) NSString *brand_class;
@property (nonatomic, copy) NSString *brand_pic;
@property (nonatomic, copy) NSString *attentions;
@property (nonatomic, copy) NSString *brand_store_id;
@end

@interface Store_infoModel : NSObject
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_avatar;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *store_collect;
@end

@interface Live_infoModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *announcement_id;
@property (nonatomic, copy) NSString *prestate;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *live_state;
@property (nonatomic, copy) NSString *video;
@end
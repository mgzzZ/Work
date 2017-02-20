//
//  HomeTVDetailModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandModel;
@interface HomeTVDetailModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *visit_count;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *ac_state;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *isRss;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *live_state;
@property (nonatomic, strong) BrandModel *brand;
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

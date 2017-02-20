//
//  ActivityMessageModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Live_Data;
@interface ActivityMessageModel : NSObject
@property (nonatomic, copy) NSString *m_id;
@property (nonatomic, copy) NSString *r_type;
@property (nonatomic, copy) NSString *t_title;
@property (nonatomic, copy) NSString *t_msg;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *jumptype;
@property (nonatomic, copy) NSString *live_state;
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, strong) Live_Data *live_data;

@end

@interface Live_Data : NSObject
@property (nonatomic, copy) NSString *store_avatar;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *announcement_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *live_msg;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *livingshowinitimg;
@property (nonatomic, copy) NSString *activity_type;

@end

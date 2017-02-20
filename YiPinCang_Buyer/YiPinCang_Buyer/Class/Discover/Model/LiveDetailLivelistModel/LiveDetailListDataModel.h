//
//  LiveDetailListDataModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveDetailListDataModel : NSObject
@property (nonatomic,copy)NSString *visit_count;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *message;
@property (nonatomic,copy)NSString *starttime;
@property (nonatomic,copy)NSString *endtime;
@property (nonatomic,copy)NSString *store_avatar;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *ac_state;
@property (nonatomic,copy)NSString *live_users;
@property (nonatomic,copy)NSString *live_like;
@property (nonatomic,copy)NSString *live_state;
@property (nonatomic,copy)NSString *start;
@property (nonatomic,copy)NSString *end;
@property (nonatomic,copy)NSString *fid;//活动Id
@property (nonatomic,copy)NSString *live_id;//活动Id
@property (nonatomic,copy)NSString *activity_pic;
@property (nonatomic,copy)NSString *activity_type;
@property (nonatomic,copy)NSString *livingshowinitimg;
@end

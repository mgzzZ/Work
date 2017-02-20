//
//  RTMPModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMPModel : NSObject
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, copy) NSString *hx_lgroupid;
@property (nonatomic, copy) NSString *hx_ggroupid;
@property (nonatomic, copy) NSString *qn_rtmppublishurl;
@property (nonatomic, copy) NSString *isfollowSeller;
@property (nonatomic, copy) NSString *live_users;
@property (nonatomic, copy) NSString *live_like;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, strong) NSArray *live_useravars;
@property (nonatomic, copy) NSString *store_avatar;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *announcement_id;
@property (nonatomic, copy) NSString *endtime;
@end

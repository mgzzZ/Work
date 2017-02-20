//
//  LiveListModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/2.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Activity_InfoModel;

@interface LiveListModel : NSObject
@property (nonatomic, strong) Activity_InfoModel *activity_info;
@property (nonatomic, strong) NSArray *store_list;
@end

@interface Activity_InfoModel : NSObject
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *activity_pic;
@property (nonatomic, copy) NSString *ac_state;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *isRss;
@end


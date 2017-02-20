//
//  Pre_stracesModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pre_stracesModel : NSObject
@property (nonatomic, copy) NSString *strace_id;
@property (nonatomic, copy) NSString *strace_storeid;
@property (nonatomic, copy) NSString *strace_storename;
@property (nonatomic, copy) NSString *strace_member;
@property (nonatomic, copy) NSString *strace_storelogo;
@property (nonatomic, copy) NSString *strace_title;
@property (nonatomic, copy) NSString *strace_time;
@property (nonatomic, copy) NSString *strace_cool;
@property (nonatomic, copy) NSString *strace_comment;
@property (nonatomic, copy) NSString *strace_type;
@property (nonatomic, copy) NSString *strace_state;
@property (nonatomic, copy) NSString *content_type;
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, copy) NSString *showmore;
@property (nonatomic, copy) NSString *video_img;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *aspect;
@property (nonatomic, copy) NSArray *strace_content;
@property (nonatomic, copy) NSArray *strace_content_thumb;
@property (nonatomic, copy) NSArray *commentlist;
@property (nonatomic, copy) NSString *islike;
@property (nonatomic, copy) NSString *isfollowSeller;
@end

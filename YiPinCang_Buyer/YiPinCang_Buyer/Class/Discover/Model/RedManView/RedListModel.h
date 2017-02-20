//
//  RedListModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedListModel : NSObject

@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,copy)NSString *strace_storeid;
@property (nonatomic,copy)NSString *strace_title;
@property (nonatomic,copy)NSString *strace_time;
@property (nonatomic,copy)NSString *strace_cool;
@property (nonatomic,copy)NSString *strace_comment;
@property (nonatomic,copy)NSString *content_type;
@property (nonatomic,copy)NSString *strace_type;
@property (nonatomic,copy)NSString *aspect;
@property (nonatomic,copy)NSString *store_name;
@property (nonatomic,copy)NSString *store_avatar;
@property (nonatomic,copy)NSString *is_follow;
@property (nonatomic,copy)NSString *strace_contentStr;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *video_img;
@property (nonatomic,copy)NSString *strace_count;
@property (nonatomic,strong)NSArray *strace_content;
@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *islike;
@property (nonatomic,copy)NSString *timestamp;
@end

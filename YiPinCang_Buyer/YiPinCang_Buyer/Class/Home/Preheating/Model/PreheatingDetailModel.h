//
//  PreheatingDetailModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/14.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentListModel.h"

@class CommentListModel;
@interface PreheatingDetailModel : NSObject
@property (nonatomic, copy) NSString *strace_storelogo;
@property (nonatomic, copy) NSString *strace_storename;
@property (nonatomic, copy) NSString *strace_title;
@property (nonatomic, copy) NSString *strace_time;
@property (nonatomic, copy) NSString *strace_comment;
@property (nonatomic, copy) NSString *strace_cool;
@property (nonatomic, copy) NSString *islike;
@property (nonatomic, copy) NSString *content_type;
@property (nonatomic, copy) NSString *video_img;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *aspect;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, strong) NSArray *strace_content;
@property (nonatomic, strong) NSArray *strace_content_thumb;
@property (nonatomic, strong) NSArray *comment_list;
@end

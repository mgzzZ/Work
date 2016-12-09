//
//  LiveNoteModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveNoteModel : NSObject

@property (nonatomic, copy) NSString *strace_id;
@property (nonatomic, copy) NSString *strace_title;
@property (nonatomic, copy) NSString *strace_contentstr;
@property (nonatomic, strong) NSMutableArray *strace_content;
@property (nonatomic, copy) NSString *strace_time;
@property (nonatomic, copy) NSString *strace_cool;
@property (nonatomic, copy) NSString *strace_comment;
@property (nonatomic, copy) NSString *content_type;
@property (nonatomic, copy) NSString *strace_type;
@property (nonatomic, copy) NSString *aspect;
@property (nonatomic, copy) NSString *live_id;
@property (nonatomic, copy) NSString *strace_storeid;
@property (nonatomic, copy) NSString *strace_storename;
@property (nonatomic, copy) NSString *strace_member;
@property (nonatomic, copy) NSString *strace_storelogo;
@property (nonatomic, copy) NSString *strace_state;
@property (nonatomic, copy) NSString *showmore;
@property (nonatomic, copy) NSString *video_img;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, strong) NSArray *commentlist;
@property (nonatomic, copy) NSString *islike;
@end

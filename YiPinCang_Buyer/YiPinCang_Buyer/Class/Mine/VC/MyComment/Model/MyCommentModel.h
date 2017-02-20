//
//  MyCommentModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/18.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject
@property (nonatomic, copy) NSString *strace_id;
@property (nonatomic, copy) NSString *scomm_content;
@property (nonatomic, copy) NSString *scomm_memberid;
@property (nonatomic, copy) NSString *scomm_membername;
@property (nonatomic, copy) NSString *scomm_memberavatar;
@property (nonatomic, copy) NSString *scomm_time;
@property (nonatomic, copy) NSString *strace_type;
@property (nonatomic, copy) NSString *strace_content_thumb;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *store_id;
@end

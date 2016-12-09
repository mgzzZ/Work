//
//  IssueModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGoodsModel : NSObject
@property (nonatomic, copy) NSString *strace_id;
@property (nonatomic, copy) NSString *goods_commonid;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *gc_name;
@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_state;
@property (nonatomic, copy) NSString *goods_serial;
@property (nonatomic, copy) NSString *strace_cool;
@property (nonatomic, copy) NSString *strace_comment;
@property (nonatomic, copy) NSString *total_storage;
@end
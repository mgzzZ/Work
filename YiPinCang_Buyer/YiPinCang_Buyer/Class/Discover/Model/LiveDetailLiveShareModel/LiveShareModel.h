//
//  LiveShareModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveShareModel : NSObject
@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,copy)NSString *strace_storeid;
@property (nonatomic,copy)NSString *strace_storename;
@property (nonatomic,copy)NSString *strace_member;
@property (nonatomic,copy)NSString *strace_storelogo;
@property (nonatomic,copy)NSString *strace_title;
@property (nonatomic,copy)NSString *strace_time;
@property (nonatomic,copy)NSString *strace_cool;
@property (nonatomic,copy)NSString *strace_comment;
@property (nonatomic,copy)NSString *strace_type;
@property (nonatomic,copy)NSString *content_type;
@property (nonatomic,copy)NSString *strace_goods;
@property (nonatomic,copy)NSString *brand_id;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *salenum;
@property (nonatomic,copy)NSString *aspect;
@property (nonatomic,strong)NSMutableArray *strace_content;
@property (nonatomic,copy)NSString *live_id;
@end

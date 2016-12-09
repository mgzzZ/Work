//
//  DiscoverLivegoodsModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverLivegoodsModel : NSObject
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
@property (nonatomic,copy)NSString *strace_goodsdata;
@property (nonatomic,copy)NSString *strace_state;
@property (nonatomic,copy)NSString *content_type;
@property (nonatomic,copy)NSString *live_id;
@property (nonatomic,strong)NSArray *strace_content;
@property (nonatomic,strong)NSArray *label;
@property (nonatomic,strong)NSString *aspect;
@property (nonatomic,strong)NSString *goods_price;
@property (nonatomic,strong)NSString *prestate;
@property (nonatomic,strong)NSString *salenum;
@end

//
//  LiveActivityModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveActivityModel.h"
@interface LiveActivityModel : NSObject
@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,copy)NSString *strace_title;
@property (nonatomic,strong)NSArray *strace_content;
@property (nonatomic,strong)NSArray *strace_content_thumb;
@property (nonatomic,copy)NSString *strace_time;
@property (nonatomic,copy)NSString *strace_cool;
@property (nonatomic,copy)NSString *strace_comment;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *goods_serial;
@property (nonatomic,copy)NSString *goods_uptime;
@property (nonatomic,copy)NSString *storage;
@property (nonatomic,copy)NSString *salenum;
@property (nonatomic,copy)NSString *aspect;
@property (nonatomic,copy)NSString *brand_id;
@property (nonatomic,copy)NSString *brand_name;
@property (nonatomic,copy)NSString *live_id;
@property (nonatomic,copy)NSString *prestate;
@property (nonatomic,copy)NSString *strace_contentStr;
@property (nonatomic,copy)NSString *goods_marketprice;
@property (nonatomic,copy)NSString *goods_discount;
@end

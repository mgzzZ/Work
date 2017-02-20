//
//  DiscoverDetailModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PModel.h"
#import "CommentListModel.h"
@class PModel;
@class CommentListModel;
@interface DiscoverDetailModel : NSObject

@property (nonatomic,copy)NSString *goods_commonid;
@property (nonatomic,copy)NSString *goods_discount;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *gc_name;
@property (nonatomic,copy)NSString *goods_image;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *brand_name;
@property (nonatomic,copy)NSString *goods_state;
@property (nonatomic,copy)NSString *goods_serial;
@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,copy)NSString *strace_storename;
@property (nonatomic,copy)NSString *strace_storelogo;
@property (nonatomic,copy)NSString *strace_time;
@property (nonatomic,copy)NSString *strace_cool;
@property (nonatomic,copy)NSString *strace_comment;
@property (nonatomic,copy)NSString *goods_salenum;//销量
@property (nonatomic,copy)NSString *prestate;//预售状态
@property (nonatomic,copy)NSString *islike;//预售状态
@property (nonatomic,strong)NSArray *p;
@property (nonatomic,strong)NSArray *strace_content;
@property (nonatomic,strong)NSArray *strace_content_thumb;
@property (nonatomic,strong)NSMutableArray *commentlist;
@property (nonatomic,strong)NSString *total_storage;
@property (nonatomic,strong)NSString *store_id;
@property (nonatomic,strong)NSString *goods_marketprice;
@end

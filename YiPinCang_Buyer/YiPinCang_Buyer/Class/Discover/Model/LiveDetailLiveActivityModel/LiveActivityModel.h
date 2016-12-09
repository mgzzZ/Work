//
//  LiveActivityModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveActivityModel : NSObject
@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,copy)NSString *strace_title;
@property (nonatomic,copy)NSString *strace_content;
@property (nonatomic,copy)NSString *live_id;
@property (nonatomic,copy)NSString *brand_id;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *storage;
@property (nonatomic,copy)NSString *brand_name;
@property (nonatomic,copy)NSString *prestate;
@end

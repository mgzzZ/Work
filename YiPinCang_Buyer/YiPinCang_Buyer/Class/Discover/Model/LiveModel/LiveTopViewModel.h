//
//  LiveTopViewModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveTopViewModel : NSObject

@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *store_name;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *store_description;
@property (nonatomic,copy)NSString *store_banner;
@property (nonatomic,copy)NSString *store_collect;
@property (nonatomic,copy)NSString *is_follow;
@property (nonatomic,copy)NSString *store_avatar;
@property (nonatomic,copy)NSArray *label;
@end

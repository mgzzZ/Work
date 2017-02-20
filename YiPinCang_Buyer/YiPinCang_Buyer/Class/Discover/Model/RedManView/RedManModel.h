//
//  RedManModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedManModel : NSObject

@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *store_name;
@property (nonatomic,copy)NSString *store_avatar;
@property (nonatomic,copy)NSString *store_collect;
@property (nonatomic,strong)NSArray *storeimg;
@end

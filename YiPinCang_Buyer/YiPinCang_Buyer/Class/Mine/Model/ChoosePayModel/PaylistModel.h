//
//  PaylistModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayTypeImg.h"
@class PayTypeImg;
@interface PaylistModel : NSObject
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)PayTypeImg *img;
@end

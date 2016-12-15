//
//  PushModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushExtrasModel.h"
@class PushExtrasModel;
@interface PushModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content_type;
@property (nonatomic,strong)PushExtrasModel *extras;
@end

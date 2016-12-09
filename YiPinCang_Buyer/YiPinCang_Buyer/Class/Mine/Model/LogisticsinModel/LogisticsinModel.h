//
//  LogisticsinModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogistcsinContentModel.h"
@class LogistcsinContentModel;
@interface LogisticsinModel : NSObject
@property (nonatomic,copy)NSString *codenumber;
@property (nonatomic,strong)NSMutableArray *content;
@property (nonatomic,copy)NSString *exname;
@end

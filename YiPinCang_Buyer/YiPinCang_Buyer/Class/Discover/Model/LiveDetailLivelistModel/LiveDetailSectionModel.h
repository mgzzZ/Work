//
//  LiveDetailSectionModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveDetailListDataModel.h"
@class LiveDetailListDataModel;
@interface LiveDetailSectionModel : NSObject
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSMutableArray *data;
@end

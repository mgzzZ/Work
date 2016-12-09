//
//  LiveDetailDefaultModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveDetailInfoModel.h"
#import "LiveDetailListModel.h"
#import "LiveDetailSectionModel.h"
@class LiveDetailInfoModel;
@class LiveDetailSectionModel;
@interface LiveDetailDefaultModel : NSObject
@property (nonatomic,strong)LiveDetailInfoModel *info;
@property (nonatomic,strong)NSMutableArray *list;

@end

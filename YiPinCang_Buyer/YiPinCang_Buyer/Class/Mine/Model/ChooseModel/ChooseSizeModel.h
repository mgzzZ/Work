//
//  ChooseSizeModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseSize_groupModel.h"
#import "ChooseSize_dataModel.h"
@class ChooseSize_groupModel;
@class ChooseSize_dataModel;
@interface ChooseSizeModel : NSObject

@property (nonatomic,strong)NSMutableArray *group;
@property (nonatomic,strong)NSMutableArray *info;

@end

//
//  PreheatingDetailVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/19.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "Pre_stracesModel.h"

typedef enum : NSUInteger {
    detailStylePerhearting = 1,
    detailStyleUserCircle,
} DetailStyleType;
@interface PreheatingDetailVC : BaseNaviConfigVC
@property (nonatomic, strong) Pre_stracesModel *tempModel;
@property (nonatomic, assign) DetailStyleType detailType;
@end

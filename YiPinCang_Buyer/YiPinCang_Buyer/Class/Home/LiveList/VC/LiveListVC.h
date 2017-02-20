//
//  LiveListVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

@interface LiveListVC : BaseNaviConfigVC

@property (nonatomic, assign) LiveListType livelistType;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *ac_state;

@end

//
//  LiveDtailLiveActivityVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "ZJScrollPageViewDelegate.h"
@interface LiveDtailLiveActivityVC : BaseNaviConfigVC<ZJScrollPageViewChildVcDelegate>

@property (nonatomic,strong)NSString *store_id;

@end

//
//  OrderListVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "ZJScrollPageViewDelegate.h"
@interface OrderListVC : BaseNaviConfigVC<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,assign) NSInteger selectIndex;

/**
 订单状态
 */
@property (nonatomic,copy)NSString *orderType;
@property (nonatomic,strong)NSString *payType;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)BOOL after;
@end

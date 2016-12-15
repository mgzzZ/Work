//
//  OrderMessageCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMessageModel.h"
#import "SystemMessageModel.h"
#import "ActivityMessageModel.h"

@interface LCPushMessageCell : UITableViewCell

@property (nonatomic, strong) OrderMessageModel *orderModel;
@property (nonatomic, strong) SystemMessageModel *systemModel;
@property (nonatomic, strong) ActivityMessageModel *activityModel;

@end

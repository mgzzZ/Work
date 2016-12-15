//
//  GoodsMessage.h
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/7.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>
#import "OrderDetailModel.h"

@interface GoodsMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

- (instancetype)initWithOrderModel:(OrderDetailModel *)orderModel conversationType:(LCCKConversationType)conversationType;
+ (instancetype)GoodsMessageWithOrderModel:(OrderDetailModel *)orderModel conversationType:(LCCKConversationType)conversationType;

@end

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

- (instancetype)initWithOrderId:(NSString *)orderId index:(NSString *)index conversationType:(LCCKConversationType)conversationType;
+ (instancetype)GoodsMessageWithOrderId:(NSString *)orderId index:(NSString *)index conversationType:(LCCKConversationType)conversationType;

@end

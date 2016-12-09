//
//  GoodsMessage.h
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/7.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>
//#import "OrdersModel.h"

static AVIMMessageMediaType const AVIMGoodsMessageType = 1;  // 1为订单消息 2为弹幕消息 //3为直播间点赞消息

@interface GoodsMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

//- (instancetype)initWithOrderModel:(OrdersModel *)orderModel conversationType:(LCCKConversationType)conversationType;
//+ (instancetype)GoodsMessageWithOrderModel:(OrdersModel *)orderModel conversationType:(LCCKConversationType)conversationType;

@end

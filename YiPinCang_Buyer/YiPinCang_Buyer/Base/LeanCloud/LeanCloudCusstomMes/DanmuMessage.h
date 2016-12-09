//
//  DanmuMessage.h
//  TaoFactory_Seller
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//
typedef NS_ENUM(NSInteger, DanmakuTransientMessageType) {
    DanmakuTransientMessageTypeOperation = 2 // 1为订单消息 2为弹幕消息 //3为直播间点赞消息
};

#import <AVOSCloudIM/AVOSCloudIM.h>
@interface DanmuMessage : AVIMTextMessage <AVIMTypedMessageSubclassing>

@end

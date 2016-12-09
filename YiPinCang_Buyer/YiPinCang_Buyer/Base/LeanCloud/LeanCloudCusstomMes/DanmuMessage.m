//
//  DanmuMessage.m
//  TaoFactory_Seller
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "DanmuMessage.h"

@implementation DanmuMessage

+ (AVIMMessageMediaType)classMediaType {
    return DanmakuTransientMessageTypeOperation;
}

+ (void)load {
    // 自定义消息需要注册
    [DanmuMessage registerSubclass];
}

@end

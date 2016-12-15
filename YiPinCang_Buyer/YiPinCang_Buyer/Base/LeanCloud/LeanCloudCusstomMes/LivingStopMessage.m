//
//  LivingStopMessage.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingStopMessage.h"

@implementation LivingStopMessage
+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageLivingStop;
}

+ (void)load {
    [LivingStopMessage registerSubclass];
}
@end

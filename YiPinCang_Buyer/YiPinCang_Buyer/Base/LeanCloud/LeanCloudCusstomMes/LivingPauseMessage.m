//
//  LivingPauseMessage.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingPauseMessage.h"

@implementation LivingPauseMessage
+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageLivingPause;
}

+ (void)load {
    [LivingPauseMessage registerSubclass];
}
@end

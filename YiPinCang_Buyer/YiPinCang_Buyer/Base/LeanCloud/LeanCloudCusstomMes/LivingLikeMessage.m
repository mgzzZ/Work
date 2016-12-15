//
//  LivingLikeMessage.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingLikeMessage.h"

@implementation LivingLikeMessage

+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageLivingLike;
}

+ (void)load {
    [LivingLikeMessage registerSubclass];
}


@end

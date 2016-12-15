//
//  GoodsTopMessage.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "GoodsTopMessage.h"

@implementation GoodsTopMessage
+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageGoodsTop;
}

+ (void)load {
    [GoodsTopMessage registerSubclass];
}
@end

//
//  GoodsIssueMessage.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/13.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "GoodsIssueMessage.h"

@implementation GoodsIssueMessage
+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageGoodsIssue;
}

+ (void)load {
    [GoodsIssueMessage registerSubclass];
}
@end

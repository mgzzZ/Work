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
    return LeanCloudCustomMessageDanmu;
}

+ (void)load {
    [DanmuMessage registerSubclass];
}

@end

//
//  LiveNoteModel.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveNoteModel.h"

@implementation LiveNoteModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"strace_contentstr" : @"strace_content",
             
             };
}


@end

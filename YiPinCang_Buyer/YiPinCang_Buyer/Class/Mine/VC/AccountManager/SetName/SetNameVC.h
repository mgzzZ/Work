//
//  SetNameVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

@interface SetNameVC : BaseNaviConfigVC
@property (nonatomic, copy) void (^NameSavedBlock)(NSString *nameStr);
@end

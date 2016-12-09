//
//  UIView+BadgeValue.h
//  YiPinCang_Buyer
//
//  Created by Apple on 15/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BadgeValue)
/*!
 *
 *  设置消息数，设置小于或等于0 、@"" 、nil 就隐藏
 */
@property (nonatomic,copy)NSString *badgeValue;

@end

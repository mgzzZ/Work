//
//  WriteCodeVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCodeVC : UIViewController<UITextFieldDelegate>


@property (nonatomic,copy)NSString *from;

/**
 注册时的电话号码
 */
@property (nonatomic,copy)NSString * phoneNumber;


/**
 校验码
 */
@property (nonatomic,copy)NSString * sign;
@end

//
//  SetPasswordVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SetPasswordRegister = 1,
    SetPasswordBinding,
} SetPasswordType;

@interface SetPasswordVC : UIViewController

/**
 标识
 */
@property (nonatomic,copy)NSString *token;

@property (nonatomic, assign) SetPasswordType setType;

@end

//
//  RegistVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface RegistVC : UIViewController<UITextFieldDelegate>

/**
 注册为1 
 忘记密码为2 
 快捷登录为3  
 更换手机号4
 */
@property (nonatomic,copy)NSString *from;

@end

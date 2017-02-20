//
//  LoginVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

@property (nonatomic, copy) void (^SuccessLoginBlock)();
@property (nonatomic, copy) NSString *resetPwdPhone;

@end

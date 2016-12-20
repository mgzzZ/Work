//
//  ChooseVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseVC : UIViewController

@property (nonatomic, assign) BOOL isChangeHomeStyle;

@property (nonatomic, copy) void (^ChangeStyleBlock)();

@end

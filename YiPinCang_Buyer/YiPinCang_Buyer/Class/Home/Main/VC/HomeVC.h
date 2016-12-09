//
//  HomeVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

+ (instancetype)shareInstance;
@property (nonatomic, copy) NSString *unReadMesCount; // 未读消息数量

@end

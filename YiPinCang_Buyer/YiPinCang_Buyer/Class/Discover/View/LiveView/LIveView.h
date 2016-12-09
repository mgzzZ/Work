//
//  LIveView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTopViewModel.h"
typedef void(^TxDidBlock)(LiveTopViewModel *model);
typedef void(^Login)();
@interface LIveView : UIView
@property (nonatomic,copy)TxDidBlock txdid;
@property (nonatomic,copy)Login login;
@end

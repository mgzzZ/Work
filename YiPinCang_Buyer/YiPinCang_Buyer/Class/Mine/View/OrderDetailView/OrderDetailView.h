//
//  OrderDetailView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderType) {
    
    OrderTypeOfState_pay = 0,
    OrderTypeOfState_sent = 1,
    OrderTypeOfSent = 2,
    OrderTypeOfFinish = 3
};

typedef void(^BtnClickBlock)(NSString *str);

@interface OrderDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame orderType:(OrderType)orderType;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,copy)BtnClickBlock btnClick;

@property (nonatomic,strong)NSString *time;

@end

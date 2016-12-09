//
//  OrderFooter.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFooter : UIView
@property (strong, nonatomic) IBOutlet UILabel *orderPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *sendPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *payPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *orderTypeLab;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLab;
@property (strong, nonatomic) IBOutlet UILabel *invTypeLab;
@property (strong, nonatomic) IBOutlet UILabel *invNameLab;
@property (strong, nonatomic) IBOutlet UILabel *invTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *invNameLabHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *invTitleLabHeight;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *contentfootView;

@end

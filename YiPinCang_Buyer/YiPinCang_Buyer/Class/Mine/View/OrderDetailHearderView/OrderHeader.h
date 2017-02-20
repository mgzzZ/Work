//
//  OrderHeader.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeader : UIView
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *areaLab;
@property (strong, nonatomic) IBOutlet UILabel *payNumberLab;
@property (strong, nonatomic) IBOutlet UILabel *orderTypeLab;
@property (strong, nonatomic) IBOutlet UILabel *downOrderTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *payPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *sendTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeLabHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sendtimeLabHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *paytimeLabHeight;
@property (strong, nonatomic) IBOutlet UIButton *changeAreaBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *payViewHeight;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *typeImg;

@end

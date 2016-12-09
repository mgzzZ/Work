//
//  OrderWaitSendWCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface OrderWaitSendWCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *merchandiseImg;
@property (strong, nonatomic) IBOutlet UILabel *merchandisePrice;
@property (strong, nonatomic) IBOutlet UILabel *merchandiseColor;

@property (strong, nonatomic) IBOutlet UILabel *merchandiseTitle;
@property (strong, nonatomic) IBOutlet UILabel *merchandiseCount;


@property (nonatomic,strong)GoodsModel *model;

@end

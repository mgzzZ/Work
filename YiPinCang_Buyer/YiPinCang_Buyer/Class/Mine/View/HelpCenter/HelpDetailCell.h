//
//  HelpDetailCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDetailModel.h"
@interface HelpDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic,strong)HelpDetailModel *model;
@end

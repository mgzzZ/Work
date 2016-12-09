//
//  LogisticsCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogistcsinContentModel.h"
@interface LogisticsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *textLab;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong)LogistcsinContentModel *model;
@end

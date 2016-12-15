//
//  ActivitySubscribeCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivitySubscribeModel.h"

@interface ActivitySubscribeCell : UITableViewCell

@property (nonatomic,strong)ActivitySubscribeModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *shopImg;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *leftImg;
@property (strong, nonatomic) IBOutlet UILabel *leftLab;
@property (strong, nonatomic) IBOutlet UIImageView *rightImg;
@property (strong, nonatomic) IBOutlet UILabel *rightLab;
@property (strong, nonatomic) IBOutlet UILabel *oldtimeLab;

@end

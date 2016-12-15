//
//  FollowCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowModel.h"
@interface FollowCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *txImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (nonatomic,strong)FollowModel *model;
@end

//
//  RedManCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedManModel.h"
@interface RedManCell : UITableViewCell

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIImageView *txImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *countLab;
@property (nonatomic,strong)RedManModel *model;
@end

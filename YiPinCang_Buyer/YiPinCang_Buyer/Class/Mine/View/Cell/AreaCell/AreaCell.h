//
//  AreaCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaListModel.h"
@interface AreaCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *setBtn;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *areaLab;
@property (nonatomic,strong)AreaListModel *model;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@end

//
//  LiveSimpleCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveSimpleData.h"
@interface LiveSimpleCell : UITableViewCell

@property (nonatomic,strong)LiveSimpleData *model;

@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *commentLab;

@end

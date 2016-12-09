//
//  shortVideoCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_stracesModel.h"

@interface shortVideoCell : UITableViewCell
@property (nonatomic, strong) Pre_stracesModel *tempModel;
@property (nonatomic, copy) void (^ButtonClickedBlock)(id object);

@end

//
//  IssueGoodsTvCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGoodsModel.h"

@interface AllGoodsTvCell : UITableViewCell
@property (nonatomic, strong) AllGoodsModel *tempModel;
@property (nonatomic, copy) void (^ButtonClickedBlock)(id object);
@end

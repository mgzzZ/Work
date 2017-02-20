//
//  LiveListCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGroupListModel.h"

@interface LiveListCell : UITableViewCell

@property (nonatomic, assign) LiveListType livelistType;
@property (nonatomic, strong) LiveGroupListModel *tempMpdel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

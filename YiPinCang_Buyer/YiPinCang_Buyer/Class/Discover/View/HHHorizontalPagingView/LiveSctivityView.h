//
//  LiveSctivityView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveActivityModel.h"



typedef void(^ActivityDidcellBlock)(NSIndexPath *index,LiveActivityModel *model);

@interface LiveSctivityView : UICollectionView
+ (LiveSctivityView *)contentTableView;
@property (nonatomic,strong)NSString *store_id;
@property (nonatomic,copy)ActivityDidcellBlock didcell;
@end

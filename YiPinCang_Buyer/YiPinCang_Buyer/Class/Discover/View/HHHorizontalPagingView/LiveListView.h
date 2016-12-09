//
//  LiveListView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveDetailListDataModel.h"
typedef void(^DidcellBlock)(NSIndexPath *index,LiveDetailListDataModel *model,NSString *type);

@interface LiveListView : UITableView

+ (LiveListView *)contentTableView;
@property (nonatomic,copy)NSString *store_id;


@property (nonatomic,copy)DidcellBlock didcell;
@end

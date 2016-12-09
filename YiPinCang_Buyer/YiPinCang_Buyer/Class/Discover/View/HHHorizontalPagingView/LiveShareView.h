//
//  LiveShareView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveShareModel.h"
typedef void(^ShareDidcellBlock)(NSIndexPath *index,LiveShareModel *model);
@interface LiveShareView : UITableView
+ (LiveShareView *)contentTableView;
@property (nonatomic,strong)NSString *store_id;
@property (nonatomic,copy)ShareDidcellBlock shareDidcell;
@end

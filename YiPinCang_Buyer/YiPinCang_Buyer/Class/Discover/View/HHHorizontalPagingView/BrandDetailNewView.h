//
//  BrandDetailNewView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveActivityModel.h"
typedef void(^BrandDidcellBlock)(NSIndexPath *index,LiveActivityModel *model);
@interface BrandDetailNewView : UICollectionView
@property (nonatomic,strong)NSString *store_id;
@property (nonatomic,strong)NSString *live_id;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)BrandDidcellBlock didcell;
+ (BrandDetailNewView *)contentTableView;
@end

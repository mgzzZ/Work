//
//  FiterBrandCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DidSeleteCellBlock)(NSIndexPath *indexPatx);
typedef void(^DiddeleteCellBlock)(NSIndexPath *indexPatx);
typedef void(^BackIdCellBlock)(NSString *type,NSString *str);

@interface FiterBrandCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)DidSeleteCellBlock didseleteCell;
@property (nonatomic,copy)DiddeleteCellBlock diddeleteCell;
@property (nonatomic,copy)BackIdCellBlock backIdCell;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)UIColor *bgColor;
@end
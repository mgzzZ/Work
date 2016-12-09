//
//  FilterView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DidSeleteCellBlock)(NSIndexPath *indexPatx);

@interface FilterView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)DidSeleteCellBlock didseleteCell;
@end

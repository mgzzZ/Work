//
//  LiveDetailLivelistVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "ZJScrollPageViewDelegate.h"

typedef void(^didscrollBlock)(CGFloat y);

@interface LiveDetailLivelistVC : BaseNaviConfigVC<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)didscrollBlock didscroll;
@property (nonatomic,assign)CGFloat yyy;

@property (nonatomic,strong)NSString *store_id;

@end

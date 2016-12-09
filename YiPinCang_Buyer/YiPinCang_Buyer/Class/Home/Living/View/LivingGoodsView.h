//
//  LivingGoodsView.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingGoodsView : UIView
<
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) NSMutableArray *commendDataArr; // 热销推荐数据容器
@property (nonatomic, strong) NSMutableArray *allGoodsDataArr; // 商品列表数据容器

@property (strong, nonatomic) IBOutlet UIView *contentView; // 父view

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tvHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *countOfHotGoods;
@property (strong, nonatomic) IBOutlet UILabel *countOfAllGoods;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) void (^CellSelectedBlock)(NSString *strace_id);

@end

//
//  GuessLikeView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemCountBlock)(NSMutableArray *dataArr);
typedef void(^DidSelectBlock)(NSIndexPath *indexPath);

@interface GuessLikeView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UICollectionView *collectView;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,copy)DidSelectBlock didSelect;
@property (nonatomic,copy)ItemCountBlock itemCount;
@end

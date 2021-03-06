//
//  ChooseSizeCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Choose_spModel.h"
typedef enum : NSUInteger {
    SEGCOUNTOFONECELL= 1,
    SEGCOUNTMORECELL,
    
} SEGCOUNTCELL;
typedef void(^SuccessBlock)(NSIndexPath *index);

typedef void(^ErrorBlock)(NSIndexPath *index);

@interface ChooseSizeCell : UICollectionViewCell



@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)NSIndexPath *index;

@property (nonatomic,copy)SuccessBlock success;

@property (nonatomic,copy)ErrorBlock error;

@property (nonatomic,strong)Choose_spModel *model;
@property (nonatomic,assign)SEGCOUNTCELL segcount;
@end

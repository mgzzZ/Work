//
//  OrderImgCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface OrderImgCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *orderImg;
@property (nonatomic,strong)GoodsModel *model;
@end

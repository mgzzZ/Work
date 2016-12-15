//
//  LiveBottomCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTopViewModel.h"
@interface LiveBottomCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (nonatomic,strong)LiveTopViewModel *model;
@end

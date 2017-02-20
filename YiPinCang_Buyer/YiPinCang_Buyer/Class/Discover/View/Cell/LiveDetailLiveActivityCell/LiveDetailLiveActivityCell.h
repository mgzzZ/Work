//
//  LiveDetailLiveActivityCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveActivityModel.h"
@interface LiveDetailLiveActivityCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (strong, nonatomic) IBOutlet UIImageView *shopImg;
@property (strong, nonatomic) IBOutlet UILabel *borderLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *numberLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labHeight;
@property (nonatomic,strong)LiveActivityModel *model;
@property (strong, nonatomic) IBOutlet OriginalPriceLab *originalPriceLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@end

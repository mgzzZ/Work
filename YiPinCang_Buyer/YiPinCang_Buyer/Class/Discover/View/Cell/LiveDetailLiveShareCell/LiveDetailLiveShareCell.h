//
//  LiveDetailLiveShareCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainerView.h"
#import "LiveShareModel.h"
@interface LiveDetailLiveShareCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *paycountLab;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *likecountLab;
@property (nonatomic,strong)UILabel *commentcountLab;
@property (nonatomic,strong)PhotoContainerView *bgImgView;
@property (nonatomic,strong)UIImageView *timeImg;
@property (nonatomic,strong)UIImageView *likeImg;
@property (nonatomic,strong)UIImageView *commentImg;
@property (nonatomic,strong)UIView *toplineView;
@property (nonatomic,strong)LiveShareModel *model;
@property (nonatomic,strong)OriginalPriceLab *originalpriceLab;//原价
@end

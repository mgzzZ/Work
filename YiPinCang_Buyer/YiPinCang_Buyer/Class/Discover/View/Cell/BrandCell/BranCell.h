//
//  BranCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainerView.h"
#import "LiveActivityModel.h"
@interface BranCell : UITableViewCell

@property (nonatomic,strong)LiveActivityModel *model;
@property (nonatomic,strong)UILabel *numberLab;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *commontCountLab;
@property (nonatomic,strong)UILabel *likeCountLab;
@property (nonatomic,strong)UIButton *payBtn;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UIImageView *commentImg;
@property (nonatomic,strong)UIImageView *likeImg;
@property (nonatomic,strong)PhotoContainerView *bgImgView;
@property (nonatomic,strong)UIView *countView;
@property (nonatomic,strong)UILabel *countLab;

@end

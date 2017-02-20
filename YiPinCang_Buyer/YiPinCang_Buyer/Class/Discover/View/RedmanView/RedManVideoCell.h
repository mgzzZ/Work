//
//  RedManVideoCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedListModel.h"
@interface RedManVideoCell : UITableViewCell
@property (nonatomic,strong)UIImageView *txImg;

@property (nonatomic,strong)UILabel *nameLab;

@property (nonatomic,strong)UILabel *countLab;

@property (nonatomic,strong)UIButton *btn;

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UILabel *commentLab;

@property (nonatomic,strong)UIImageView *commentImg;

@property (nonatomic,strong)UILabel *likeCountLab;

@property (nonatomic,strong)UIButton *likeBtn;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIButton *playBtn;

@property (nonatomic,strong)UIButton *txBtn;

@property (nonatomic,strong)RedListModel *model;
@end

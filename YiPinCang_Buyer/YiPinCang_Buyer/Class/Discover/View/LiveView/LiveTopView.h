//
//  LiveTopView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTopViewModel.h"
@interface LiveTopView : UIView
@property (nonatomic,strong)UIImageView *bgImg;
@property (nonatomic,strong)UIImageView *topImg;
@property (nonatomic,strong)UIImageView *txImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *fansLab;
@property (nonatomic,strong)UIButton *txBtn;
@property (nonatomic,strong)UIButton *fllowBtn;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)YYLabel *classLab;
@property (nonatomic,strong)LiveTopViewModel *model;
@end

//
//  DiscoverCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainerView.h"
#import "DiscoverLivegoodsModel.h"


typedef void(^TxBtnClick)(NSString *str);

@interface DiscoverCell : UITableViewCell
@property (nonatomic,strong)UIImageView *txImg;
@property (nonatomic,strong)YYLabel *nameLab;
@property (nonatomic,strong)YYLabel *titlelab;
@property (nonatomic,strong)YYLabel *timeLab;
@property (nonatomic,strong)UILabel *likeLab;
@property (nonatomic,strong)UILabel *commentLab;
@property (nonatomic,strong)UIImageView *likeImg;
@property (nonatomic,strong)UIImageView *commentImg;
@property (nonatomic,strong)YYLabel *lableView;
@property (nonatomic,strong)PhotoContainerView *bgImgView;
@property (nonatomic,strong)DiscoverLivegoodsModel *model;
@property (nonatomic,assign)BOOL isAsyan;
@property (nonatomic,strong)UILabel *gudingLab;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *payCountLab;
@property (nonatomic,strong)UIImageView *typeImg;
@property (nonatomic,strong)UIButton *payBtn;

@property (nonatomic,copy)TxBtnClick txBtnClickBlock;
@end

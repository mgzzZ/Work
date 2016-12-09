//
//  LiveDetailLiveVideoCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/2.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveNoteModel.h"
@interface LiveDetailLiveVideoCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIButton *playBtn;

@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIImageView *likeImg;

@property (nonatomic,strong)UIImageView *commentImg;

@property (nonatomic,strong)UILabel *likeLab;

@property (nonatomic,strong)UILabel *commentLab;
@property (nonatomic,strong)LiveNoteModel *model;
@end

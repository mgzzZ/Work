//
//  DiscoverCommentCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"
@interface DiscoverCommentCell : UITableViewCell


@property (nonatomic, strong)UIImageView *txImg;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *timeLab;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)CommentListModel *model;
@property (nonatomic, strong)UIButton *txBtn;
@end

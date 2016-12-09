//
//  OrderTypeCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

typedef void(^BtnClickBlock)(OrderListModel *model,NSString *str);

@interface OrderTypeCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *stateLab;
@property (strong, nonatomic) IBOutlet UILabel *countLab;
@property (strong, nonatomic) IBOutlet UILabel *payPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UILabel *merchandisePriceLab;
@property (nonatomic,strong)OrderListModel *model;

@property (strong, nonatomic) IBOutlet UILabel *merchandiseTitleLab;

@property (strong, nonatomic) IBOutlet UIImageView *merchandiseImg;
@property (strong, nonatomic) IBOutlet UILabel *merchandiseColor;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeImgWidth;
@property (strong, nonatomic) IBOutlet UILabel *countMoreLab;
@property (strong, nonatomic) IBOutlet UILabel *payPriceMoreLab;
@property (strong, nonatomic) IBOutlet UILabel *timeMoreLab;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *leftMoreBtn;
@property (strong, nonatomic) IBOutlet UILabel *stateMoreLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moreImgWidth;
@property (weak, nonatomic) IBOutlet UILabel *merchandiseMoreTypeLab;
@property (strong, nonatomic) IBOutlet UIButton *rightMoreBtn;
@property (nonatomic ,strong) dispatch_source_t timer;
@property (nonatomic,strong) BtnClickBlock btnclick;
@end

//
//  ShoppongCarCell.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
#import "Shoppingcar_dataModel.h"



typedef void(^SeleteBtnClick)(UIButton *sender);
typedef void(^DeleteBlock)();
typedef void(^ChooseSizeBlock)();
typedef void(^PayCountBlock)(NSString *num);

@interface ShoppongCarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *Choose1Btn;
@property (strong, nonatomic) IBOutlet UIImageView *storeImg;
@property (strong, nonatomic) IBOutlet UILabel *price1Lab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLab;
@property (strong, nonatomic) IBOutlet PPNumberButton *payCount1;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *choose2Btn;
@property (weak, nonatomic) IBOutlet UIImageView *strre2Img;
@property (weak, nonatomic) IBOutlet PPNumberButton *payCount2;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (nonatomic ,strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UILabel *price2Lab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab2;
@property (weak, nonatomic) IBOutlet UIButton *chooseSizeBtn;
@property (nonatomic,strong)Shoppingcar_dataModel *model;

@property (nonatomic,copy)DeleteBlock deleteBlock;
@property (nonatomic,copy)ChooseSizeBlock chooseBlock;
@property (nonatomic,copy)SeleteBtnClick seleteBlock;
@property (nonatomic,copy)PayCountBlock payCountBlock;
@end

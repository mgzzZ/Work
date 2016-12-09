//
//  ClearingView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/21.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeleteBtnClickBlock)(UIButton *btn);
typedef void(^CliearingBtnClickBlock)();

@interface ClearingView : UIView

@property (nonatomic,strong)UIButton *clearingBtn;
@property (nonatomic,strong)UIButton *seleteBtn;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *seleteLab;

@property (nonatomic,copy)SeleteBtnClickBlock seleteBtnBlock;
@property (nonatomic,copy)CliearingBtnClickBlock cliearingBtnBlock;

@end

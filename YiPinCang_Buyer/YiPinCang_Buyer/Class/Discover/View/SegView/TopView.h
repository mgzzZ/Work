//
//  TopView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidBtnClick)(UIButton *btn,NSInteger tag);

@interface TopView : UIView




@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIButton *priceBtn;
@property (strong, nonatomic) IBOutlet UIButton *brandBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherBtn;
@property (strong, nonatomic) IBOutlet UIButton *recommendBtn;
@property (copy, nonatomic)DidBtnClick didBtnClick;
@end

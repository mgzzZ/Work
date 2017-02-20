//
//  ShopCarView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopCarBlock)();
typedef void(^ClearingBlock)();


@interface ShopCarView : UIView
@property (nonatomic,strong)UIImageView *car;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIButton *carBtn;
@property (nonatomic,copy)ShopCarBlock shopcar;
@property (nonatomic,copy)ClearingBlock clearing;
@property (nonatomic,assign)BOOL isSelected;
- (void)openAnimation;
@end

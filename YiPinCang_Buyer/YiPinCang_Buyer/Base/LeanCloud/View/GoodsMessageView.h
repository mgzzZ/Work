//
//  GoodsMessageView.h
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/8.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface GoodsMessageView : UIView

+ (id)GoodsMessageView;

- (void)configureWithModel:(OrderDetailModel *)model;

@property (nonatomic, copy) void (^GoodsMesViewClickBlock)(id object);

@end

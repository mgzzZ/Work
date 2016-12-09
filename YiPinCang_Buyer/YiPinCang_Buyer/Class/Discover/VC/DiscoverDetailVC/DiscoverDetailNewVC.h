//
//  DiscoverDetailNewVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
typedef NS_ENUM(NSUInteger, SelectedButtonType) {
    BrandBtnTag = 1000,
    BrandDetailBtnTag,
    BrandFllowBtnTag
    
};
@interface DiscoverDetailNewVC : BaseNaviConfigVC
@property (nonatomic,strong)NSString *live_id;
@property (nonatomic,copy)NSString *type;
@end

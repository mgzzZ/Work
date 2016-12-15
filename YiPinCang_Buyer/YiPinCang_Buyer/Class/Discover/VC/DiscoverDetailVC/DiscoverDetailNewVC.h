//
//  DiscoverDetailNewVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "TempHomePushModel.h"
typedef NS_ENUM(NSUInteger, SelectedButtonType) {
    BrandBtnTag = 1000,
    BrandDetailBtnTag,
    BrandFllowBtnTag
    
};
@interface DiscoverDetailNewVC : BaseNaviConfigVC
@property (nonatomic,strong)NSString *live_id;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)TempHomePushModel *tempModel;//跳转活动详情
@property (nonatomic,copy)NSString *livingshowinitimg;//跳转直播中详情用
@property (nonatomic,copy)NSString *message;
@end

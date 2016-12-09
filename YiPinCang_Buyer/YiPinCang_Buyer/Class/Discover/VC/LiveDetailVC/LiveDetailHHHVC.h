//
//  LiveDetailHHHVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

@interface LiveDetailHHHVC : BaseNaviConfigVC
typedef NS_ENUM(NSUInteger, HeaderSelectedButtonType) {
    LikeBtnTag = 1000,
    MessageTag,
   
};
@property (nonatomic,strong)NSString *store_id;
@end

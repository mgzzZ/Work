//
//  DiscoverDetailVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"

typedef void(^BackLikeAndComment)(NSString *likeCount,NSString * isLike,NSString *commentCount);
@interface DiscoverDetailVC : BaseNaviConfigVC

@property (nonatomic,copy)NSString *live_id;
@property (nonatomic,copy)NSString *strace_id;
@property (nonatomic,strong)NSString *typeStr;

@property (nonatomic,copy)BackLikeAndComment backBlock;
@end

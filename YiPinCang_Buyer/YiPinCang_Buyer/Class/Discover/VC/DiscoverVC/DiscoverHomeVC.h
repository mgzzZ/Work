//
//  DiscoverHomeVC.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "ZJScrollPageViewDelegate.h"
typedef void(^DidCellBlcok)(NSString *strace_id,NSString *live_id);
typedef void(^DidtxBlcok)(NSString *strace_id);
@interface DiscoverHomeVC : BaseNaviConfigVC<ZJScrollPageViewChildVcDelegate>
@property(nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,copy)DidCellBlcok didcell;
@property (nonatomic,copy)DidtxBlcok didtx;
@property (nonatomic,copy)NSString *url;//淘好货和动态
- (void)segViewhiden;
@end

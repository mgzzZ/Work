//
//  DiscoverSegView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"

typedef void(^DidCellBlcok)(NSString *strace_id,NSString *live_id);
typedef void(^DidtxBlcok)(NSString *strace_id);
@interface DiscoverSegView : UIView<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic,strong)UIViewController *supVC;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)DidCellBlcok didcell;
@property (nonatomic,copy)DidtxBlcok didtx;
@property (nonatomic,copy)NSString *url;//淘好货或者动态的网络请求URL
@end

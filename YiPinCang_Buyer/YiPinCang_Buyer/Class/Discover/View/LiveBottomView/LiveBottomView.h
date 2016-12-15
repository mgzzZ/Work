//
//  LiveBottomView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveSimpleData.h"
#import "TempHomePushModel.h"
typedef void(^PushToMessageBlock)(NSString *hx_uname);
typedef void(^DidCellBlock)(TempHomePushModel *model);

@interface LiveBottomView : UIView

@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)DidCellBlock didcell;
@property (nonatomic,copy)PushToMessageBlock pushMessage;


- (void)animationShow;

- (void)animationHiden;

@end

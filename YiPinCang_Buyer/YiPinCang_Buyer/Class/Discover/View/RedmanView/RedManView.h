//
//  RedManView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RedManViewToMan = 1,
    RedManViewToNote,
    RedManViewToShop,
} RedManViewToView;
typedef void(^DidBannerView)(NSString *str,UrlSechmeType type,NSString *activityType);
typedef void(^DidCellBlock)(id model,RedManViewToView toView);
typedef void(^DidScrollBlock)(CGFloat offset);
@interface RedManView : UIView
@property (nonatomic,copy)DidScrollBlock didscroll;
@property (nonatomic,copy)DidCellBlock didcell;
@property (nonatomic,copy)DidBannerView didbanner;
@end

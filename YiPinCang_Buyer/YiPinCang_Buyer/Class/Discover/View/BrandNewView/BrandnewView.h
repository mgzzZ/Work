//
//  BrandnewView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveDetailListDataModel.h"
#import "GuessModel.h"
typedef void(^DidBannerView)(NSString *str,UrlSechmeType type,NSString *activityType);

typedef void(^DidBrandcellBlock)(NSIndexPath *index,LiveDetailListDataModel *model,NSString *type);

typedef void(^DidLikeBlock)(NSIndexPath *index,GuessModel *model);

typedef void(^DidScrollBlock)(CGFloat offset);

@interface BrandnewView : UIView
@property (nonatomic,copy)DidBrandcellBlock didcell;
@property (nonatomic,copy)DidLikeBlock didlike;
@property (nonatomic,copy)DidScrollBlock didscroll;
@property (nonatomic,copy)DidBannerView didbanner;
- (void)reload;
@end

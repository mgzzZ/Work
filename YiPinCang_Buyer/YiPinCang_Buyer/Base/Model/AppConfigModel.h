//
//  AppConfigModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShareStoreModel;
@class ShareGoodsModel;
@class ShareWillActivityModel;
@class ShareLiveActivityModel;
@class ShareEndActivityModel;
@class ShareBrandModel;
@interface AppConfigModel : NSObject

@property (nonatomic, strong) ShareStoreModel *share_store;
@property (nonatomic, strong) ShareGoodsModel *share_goods;
@property (nonatomic, strong) ShareWillActivityModel *share_will_activity;
@property (nonatomic, strong) ShareLiveActivityModel *share_live_activity;
@property (nonatomic, strong) ShareEndActivityModel *share_end_activity;
@property (nonatomic, strong) ShareBrandModel *share_brand;

@end

@interface ShareStoreModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ShareGoodsModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ShareWillActivityModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ShareLiveActivityModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ShareEndActivityModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ShareBrandModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

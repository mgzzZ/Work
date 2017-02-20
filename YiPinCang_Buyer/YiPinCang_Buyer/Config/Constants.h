//
//  Constants.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/**
 *  登录相关
 */
#define KEY_KEYCHAIN_SERVICE   @"KEY_KEYCHAIN_SERVICE"
#define KEY_KEYCHAIN_NAME      @"KEY_KEYCHAIN_Name"
#define kUserIsLogin           @"kUserIsLogin"

#define kRandomColor @[]

//Callback with Foundation type
typedef void (^YPCBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^YPCViewControllerBooleanResultBlock)(__kindof UIViewController *viewController, BOOL succeeded, NSError *error);

typedef void (^YPCIntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^YPCStringResultBlock)(NSString *string, NSError *error);
typedef void (^YPCDictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^YPCArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^YPCSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^YPCDataResultBlock)(NSData *data, NSError *error);
typedef void (^YPCIdResultBlock)(id object, NSError *error);
typedef void (^YPCIdBoolResultBlock)(BOOL succeeded, id object, NSError *error);
typedef void (^YPCRequestAuthorizationBoolResultBlock)(BOOL granted, NSError *error);

//Callback with Function object
typedef void (^YPCVoidBlock)(void);
typedef void (^YPCErrorBlock)(NSError *error);
typedef void (^YPCImageResultBlock)(UIImage * image, NSError *error);
typedef void (^YPCProgressBlock)(NSInteger percentDone);


/**
 *  pageVC类型(足迹&收藏)
 */
typedef NS_ENUM(NSUInteger, PageSubViewType){
    PageSubViewHistory = 0, // 足迹
    PageSubViewCollect, // 收藏
};

/**
 *  当前网络类型
 */
typedef NS_ENUM(NSUInteger, CurrentNetWorkType){
    CurrentNetWorkUnknown = 0,
    CurrentNetWork3G4G,
    CurrentNetWorkWifi,
    CurrentNetWorkNotReachable,
};
/**
 *  UrlScheme规则
 */
typedef NS_ENUM(NSUInteger, UrlSechmeType){
    urlSechmeNone = 0, // 空
    urlSechmeWebView, // 网页
    urlSechmeGoodsDetail, // 商品详情
    urlSechmeActivityDeatail, // 活动详情
    urlSechmeLivingGroupDetail, // 直播中详情
    urlSechmeBrandDetail, // 品牌详情
};

/*!
 *
 *    conversationList系统消息类型
 *
 */
typedef enum : NSUInteger {
    LCMessageTypeSystem = 1,
    LCMessageTypeOrder = 4,
    LCMessageTypeActivity = 2,
} LCMessageType;


typedef int8_t LeanCloudCustomMessageType;
enum : LeanCloudCustomMessageType {
    LeanCloudCustomMessageGoods             = 1, // 商品消息
    LeanCloudCustomMessageDanmu             = 2, // 弹幕暂态消息
    LeanCloudCustomMessageLivingLike        = 3, // 直播间点赞暂停消息
    LeanCloudCustomMessageGoodsTop          = 4, // 直播间商品弹出推荐暂态消息
    LeanCloudCustomMessageGoodsIssue        = 5, // 直播间商品发布暂态消息
    LeanCloudCustomMessageLivingPause       = 6, // 直播暂停暂态消息
    LeanCloudCustomMessageLivingStop        = 7, // 直播停止暂态消息
};

/*!
 *
 *    首页活动状态类型
 *
 */
static NSString *const KEY_Will_Activity = @"will_activity";
static NSString *const KEY_Start_Activity = @"start_activity";
static NSString *const KEY_End_Activity = @"stop_activity";

typedef NS_ENUM(NSUInteger, LiveListType){
    LiveListOfLiving = 0, //直播中
    LiveListOfPreHearting, //预热
    LiveListOfEnd, //往期回顾
};

/**
 *  九宫格图层类型
 */
typedef NS_ENUM(NSUInteger, PhotoContainerType){
    PhotoContainerTypeNormal = 0, // 宽度不充满屏幕, 正常类型
    PhotoContainerTypeFullScreenWidth, // 宽度充满屏幕
    PhotoContainerTypeFindScreenWidth,//发现页面特殊要求
    PhotoContainerTypeGeneral,//九张图一样大小
};
/**
 *  九宫格图层模式  是否带缩略图
 */
typedef NS_ENUM(NSUInteger, PhotoContainerModeType){
    PhotoContainerModeTypeNormal = 0, // 没有
    PhotoContainerModeTypeHave, // 有
};

/**
 *  分享类型
 */
typedef NS_ENUM(NSUInteger, ShareStateType){
    ShareStateTypeStore = 0, // 直播组
    ShareStateTypeGoods, // 商品
    ShareStateTypeStartActivity, // 正在直播活动
    ShareStateTypeWillActivity, // 预热活动
    ShareStateTypeEndActivity, // 已结束活动
    ShareStateTypeBrand, // 品牌
    ShareStateTypeBrandActivity,
};

#endif /* Constants_h */

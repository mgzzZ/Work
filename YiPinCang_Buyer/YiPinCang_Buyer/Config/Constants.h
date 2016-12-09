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
 *    主题选择
 *
 */
typedef NS_ENUM(NSUInteger, HomeStyleType){
    homeStyleFemale = 0, // 女性
    homeStyleMale, // 男性
    homeStyleChildren, // 商品详情
    homeStyleHousehold // 居家
};
/*!
 *
 *    首页活动状态类型
 *
 */
static NSString *const KEY_Will_Activity = @"will_activity";
static NSString *const KEY_Start_Activity = @"start_activity";
static NSString *const KEY_End_Activity = @"stop_activity";
/**
 *  九宫格图层类型
 */
typedef NS_ENUM(NSInteger, PhotoContainerType){
    PhotoContainerTypeNormal = 0, // 宽度不充满屏幕, 正常类型
    PhotoContainerTypeFullScreenWidth, // 宽度充满屏幕
};

#endif /* Constants_h */

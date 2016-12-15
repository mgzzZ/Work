//
//  YPCRequestCenter.h
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/5.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <AFNetworkReachabilityManager.h>

@interface YPCRequestCenter : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property (nonatomic, copy) NSString *sID; // USER_ID
@property (nonatomic, copy) NSString *uID; // SESSION_ID
@property (nonatomic, strong) UserModel *model; // USER_DATA_MODEL

@property (nonatomic, assign) HomeStyleType homeStyleType;

@property (nonatomic, copy) NSString *kShopingCarCount; // 购物车数量
@property (nonatomic, copy) NSString *kUnReadMesCount; // 消息未读数量

/*!
 *
 *    判断网络是否可用
 *
 */
+ (BOOL)isVaildNetwork;
/*!
 *
 *    返回网络状态
 *
 */
+ (CurrentNetWorkType)getCurrentNetworkType;
/*!
 *
 *    获取session
 *
 */
+ (NSDictionary *)getUserInfo;
/*!
 *
 *    拼接session
 *
 */
+ (NSDictionary *)getUserInfoAppendDictionary:(NSDictionary *)dic;

/*!
 *
 *    session缓存到keychain
 *
 */
+ (void)cacheUserKeychainWithSID:(NSString *)sid;
/*!
 *
 *    清除keychain账户session
 *
 */
+ (void)removeCacheUserKeychain;
/*!
 *
 *    设置用户信息数据
 *
 */
+ (void)setUserInfoWithResponse:(id)response;
/*!
 *
 *    用户是否登录
 *
 */
+ (BOOL)isLogin;
/*!
 *
 *    用户是否登录, 并模态登录页面
 *
 */
+ (BOOL)isLoginAndPresentLoginVC:(UIViewController *)vc;
/*!
 *
 *    设置登录状态为YES
 *
 */
+ (void)setUserLogin;
/*!
 *
 *    设置登录状态为NO
 *
 */
+ (void)setUserLogout;

@end

//
//  AppDelegate.m
//  YiPinCang_Buyer
//
//  Created by Apple on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "LeanChatFactory.h"
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaHandler.h>
#import "ChooseVC.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <SAMKeychain.h>
#import <PLPlayerKit.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<WXApiDelegate, JPUSHRegisterDelegate>


@end

@implementation AppDelegate

+ (AppDelegate *) shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NSThread sleepForTimeInterval:2.0];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /*!
     *
     *    状态栏设置
     *
     */
    application.statusBarStyle = UIStatusBarStyleDefault;
    application.statusBarHidden = NO;

    /*!
     *
     *    APP第三方相关配置
     *
     */
    [self appConfigInitWithOptions:launchOptions];
    
    /*!
     *
     *    跟视图
     *
     */
    [self setRootViewController];
    
    return YES;
}

- (void)setRootViewController
{
    ChooseVC *logVC = [ChooseVC new];
    UINavigationController *logNavi = [[UINavigationController alloc] initWithRootViewController:logVC];
    logVC.navigationController.navigationBar.hidden = YES;
    logVC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController = logNavi;
}

- (void)appConfigInitWithOptions:(NSDictionary *)launchOptions
{
    [self setNetWorkConfig];
    [self leanCloudInit];
    [self UMengInit];
    [self JPushInitWithOptions:launchOptions];
    [self judgementKeychainIsOutOfDate];
}

- (void)leanCloudInit
{
    [LeanChatFactory invokeThisMethodInDidFinishLaunching];
}

- (void)UMengInit
{
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kUMWXAppID appSecret:kUMWXAppSecret redirectURL:kUMShareURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kUMQQAppID  appSecret:kUMQQAppKey redirectURL:kUMShareURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kUMSinaAppKey  appSecret:kUMSinaAppSecret redirectURL:kUMSinaCallBackURL];
}

- (void)JPushInitWithOptions:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:nil apsForProduction:YES];
}

- (void)setNetWorkConfig
{
#pragma mark - 本地服务器
//    NSString *url = @"http://192.168.1.56/ypcang-api/api/ecapi/index.php?url=";
#pragma mark - 外网服务器
   NSString *url = @"http://api.gongchangtemai.com/index.php?url=";
    [YPCNetworking updateBaseUrl:url];
    [YPCNetworking setTimeout:15.f];
//    [YPCNetworking enableInterfaceDebug:YES];
    [YPCNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];
    [YPCNetworking cacheGetRequest:YES shoulCachePost:NO];
}

- (void)judgementKeychainIsOutOfDate
{
    NSString *SID = [SAMKeychain passwordForService:KEY_KEYCHAIN_SERVICE account:KEY_KEYCHAIN_NAME];
    if (SID) {
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            NSDictionary *sessionDic = @{
                                         @"session" : @{@"sid" : SID,
                                                        @"uid" : @"0"},
                                         @"registration_id" : registrationID
                                         };
            [YPCNetworking postWithUrl:@"shop/user/checkinfo"
                          refreshCache:YES
                                params:sessionDic
                               success:^(id response) {
                                   NSNumber *num = [NSNumber numberWithInteger:0];
                                   if (response[@"status"][@"succeed"] != num) {
                                       [YPCRequestCenter setUserInfoWithResponse:response];
                                       [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                           [YPCRequestCenter setUserLogin];
                                       } failed:^(NSError *error) {
                                           YPCAppLog(@"%@", [error description]);
                                           [YPCRequestCenter removeCacheUserKeychain];
                                       }];
                                   }else {
                                       [YPCRequestCenter removeCacheUserKeychain];
                                   }
                               }
                                  fail:^(NSError *error) {
                                      [YPCRequestCenter removeCacheUserKeychain];
                                      YPCAppLog(@"%@", [error description]);
                                  }];
        }];
    }else {
        [YPCRequestCenter removeCacheUserKeychain];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
            return YES;
        }
        
        if ([url.host isEqualToString:@"alipayclient"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          
                                                      }];
            return YES;
        }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
               
            }];
            return YES;
        }
        //微信支付
        if ([url.host isEqual:@"pay"]){
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

//支付结果
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
            }
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [LeanChatFactory invokeThisMethodInApplicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [LeanChatFactory invokeThisMethodInApplicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [LeanChatFactory invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [LeanChatFactory invokeThisMethodInApplication:application didReceiveRemoteNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    YPCAppLog(@"LeanCloud注册失败，无法获取设备 ID, 具体错误: %@", error);
}

- (void)didReceiveAccountDidOutOfDate
{
//    LoginVC *logVC = [LoginVC new];
//    [self.window.rootViewController presentViewController:logVC animated:YES completion:nil];
}

// 监听评论
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
}

@end

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
#import <UMSocialCore/UMSocialCore.h>
//#import "ChooseVC.h"
#import "AppConfigModel.h"
#import "YJMGuideViewManager.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <SAMKeychain.h>
#import <JSPatchPlatform/JSPatch.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件

#import "LiveListVC.h"
#import "DiscoverDetailVC.h"
#import "LiveDetailHHHVC.h"
#import "PreheatingVC.h"
#import "PhotoLivingVC.h"
#import "VideoPlayerVC.h"
#import "LivingVC.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <UMMobClick/MobClick.h>

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
    
    /*!
     *
     *    引导页
     *
     */
    [self showAppFirstStartGuideView];
    
    return YES;
}

- (void)setRootViewController
{
//    ChooseVC *cVC = [ChooseVC new];
//    cVC.isChangeHomeStyle = NO;
//    UINavigationController *logNavi = [[UINavigationController alloc] initWithRootViewController:cVC];
//    cVC.navigationController.navigationBar.hidden = YES;
//    cVC.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.window.rootViewController = logNavi;
    CATransition *transition = [CATransition animation];
    transition.duration = .5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFromBottom;
    UITabBarController *rootTab = [YPC_Tools setupTabBar];
    [AppDelegate shareAppDelegate].window.rootViewController = rootTab;
    [[AppDelegate shareAppDelegate].window.layer addAnimation:transition forKey:@"animation"];
}

- (void)showAppFirstStartGuideView
{
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"1navigationpage"]];
    [images addObject:[UIImage imageNamed:@"2navigationpage"]];
    [images addObject:[UIImage imageNamed:@"3navigationpage"]];
    [images addObject:[UIImage imageNamed:@"4navigationpage"]];
    
    [[YJMGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                   andButtonTitle:@""
                                              andButtonTitleColor:[UIColor whiteColor]
                                                 andButtonBGColor:[UIColor clearColor]
                                             andButtonBorderColor:[UIColor clearColor]];
    
    // 获取分享等等相关初试数据
//    [self getAppConfigData];
}

//- (void)getAppConfigData
//{
//    [YPCNetworking getWithUrl:@"merchant/config"
//                 refreshCache:YES
//                      success:^(id response) {
//                          if ([YPC_Tools judgeRequestAvailable:response]) {
//                              [YPCRequestCenter shareInstance].configModel = [AppConfigModel mj_objectWithKeyValues:response[@"data"][@"share_data"]];
//                          }
//                      } fail:^(NSError *error) {
//                          
//                      }];
//}

- (void)appConfigInitWithOptions:(NSDictionary *)launchOptions
{
    [WXApi registerApp:@"wxff15efaf15adc6f8"];
    [self setNetWorkConfig];
    [self leanCloudInit];
    [self UMengInit];
    [self JPushInitWithOptions:launchOptions];
//    [self judgementKeychainIsOutOfDate];
    [JSPatch setupLogger:^(NSString *msg) {
         YPCAppLog(@"JJJJSPATH--%@", msg);
    }];
    [JSPatch startWithAppKey:@"ae81c4586fd2e1c1"];
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
}

- (void)leanCloudInit
{
    [LCChatKit setAppId:LeanCloudAppId appKey:LeanCloudAppKey];
    [LeanChatFactory invokeThisMethodInDidFinishLaunching];
}

- (void)UMengInit
{
    // 友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kUMWXAppID appSecret:kUMWXAppSecret redirectURL:kUMShareURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kUMQQAppID  appSecret:kUMQQAppKey redirectURL:kUMShareURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kUMSinaAppKey  appSecret:kUMSinaAppSecret redirectURL:kUMSinaCallBackURL];
    // 友盟统计
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
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

   NSString *url = @"https://test.gongchangtemai.com/index.php?url=";
  //  NSString *url = @"http://192.168.0.107/ypcang-api/index.php?url=";
//    NSString *url = @"http://192.168.1.54/ypcang-api/api/ecapi/index.php?url=";
//    NSString *url = @"http://192.168.1.56/ypcang-api/api/ecapi/index.php?url=";
//   NSString *url = @"http://192.168.0.118/ypcang-api/api/ecapi/index.php?url=";
#pragma mark - 外网服务器
//   NSString *url = @"https://api.gongchangtemai.com/index.php?url=";
//    NSString *url = @"https://api.gongchangtemai.com/ypcang-api/api/ecapi/index.php?url=";
    [YPCNetworking updateBaseUrl:url];
    [YPCNetworking setTimeout:15.f];
//    [YPCNetworking enableInterfaceDebug:YES];
    [YPCNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];
    [YPCNetworking cacheGetRequest:YES shoulCachePost:NO];
}

//- (void)judgementKeychainIsOutOfDate
//{
//    NSString *SID = [SAMKeychain passwordForService:KEY_KEYCHAIN_SERVICE account:KEY_KEYCHAIN_NAME];
//    if (SID) {
//        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//            NSDictionary *sessionDic = @{
//                                         @"session" : @{@"sid" : SID,
//                                                        @"uid" : @"0"},
//                                         @"registration_id" : registrationID != nil ? registrationID : @"0"
//                                         };
//            [YPCNetworking postWithUrl:@"shop/user/checkinfo"
//                          refreshCache:YES
//                                params:sessionDic
//                               success:^(id response) {
//                                   NSNumber *num = [NSNumber numberWithInteger:0];
//                                   if (response[@"status"][@"succeed"] != num) {
//                                       [YPCRequestCenter setUserInfoWithResponse:response];
//                                       [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
//                                           [YPCRequestCenter setUserLogin];
//                                       } failed:^(NSError *error) {
//                                           YPCAppLog(@"%@", [error description]);
//                                           [YPCRequestCenter removeCacheUserKeychain];
//                                       }];
//                                   }else {
//                                       [YPCRequestCenter removeCacheUserKeychain];
//                                   }
//                               }
//                                  fail:^(NSError *error) {
//                                      [YPCRequestCenter removeCacheUserKeychain];
//                                      YPCAppLog(@"%@", [error description]);
//                                  }];
//        }];
//    }else {
//        [YPCRequestCenter removeCacheUserKeychain];
//    }
//}


//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if (!url) {
        return NO;
    }
    if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"ypcbuyer://"]) {
        [self pushPage:[self clippingURLwithStr:[NSString stringWithFormat:@"%@",url]]];
        return YES;
    }else{
        //        [YPC_Tools customAlertViewWithTitle:urlString Message:nil BtnTitles:nil CancelBtnTitle:@"OK" DestructiveBtnTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        // 其他如支付等SDK的回调
        // 其他如支付等SDK的回调
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
               
                if ([resultDic[@"result"] isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
                }
                
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
        if ([[url absoluteString] rangeOfString:@"wxff15efaf15adc6f8://pay"].location == 0) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        return result;
    }

    
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (!url) {
        return NO;
    }
    if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"ypcbuyer://"]) {
        [self pushPage:[self clippingURLwithStr:[NSString stringWithFormat:@"%@",url]]];
        return YES;
    }else{
//        [YPC_Tools customAlertViewWithTitle:urlString Message:nil BtnTitles:nil CancelBtnTitle:@"OK" DestructiveBtnTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        // 其他如支付等SDK的回调
        // 其他如支付等SDK的回调
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
                if ([resultDic[@"result"] isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
                }
                
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
               
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
        if ([[url absoluteString] rangeOfString:@"wxff15efaf15adc6f8://pay"].location == 0) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        return result;
    }
    
 

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"ypcbuyer://"]) {
        [self pushPage:[self clippingURLwithStr:[NSString stringWithFormat:@"%@",url]]];
        return YES;
    }else{
        //        [YPC_Tools customAlertViewWithTitle:urlString Message:nil BtnTitles:nil CancelBtnTitle:@"OK" DestructiveBtnTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        // 其他如支付等SDK的回调
        // 其他如支付等SDK的回调
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
              
                if ([resultDic[@"result"] isEqualToString:@""]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
                }
                
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                
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
        if ([[url absoluteString] rangeOfString:@"wxff15efaf15adc6f8://pay"].location == 0) {
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        return result;
    }

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
                [YPC_Tools showSvpWithNoneImgHud:@"支付失败"];
                [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                break;
        }
    }
}



- (BOOL)applicationOpenURL:(NSURL*)url{
    if ([[url absoluteString] rangeOfString:@"wxff15efaf15adc6f8://pay"].location == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
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
//    [LeanChatFactory invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken constructingInstallationWithBlock:^(AVInstallation * _Nonnull currentInstallation) {
       currentInstallation.deviceProfile = @"APNS_Shop_Development";
    }];
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

- (NSDictionary *)clippingURLwithStr:(NSString *)url{
    NSString *baseUrl = [url substringFromIndex:11];
    NSRange range = [baseUrl rangeOfString:@"?"];
    NSString *typeStr = [baseUrl substringToIndex:range.location];
    
    NSString *parameter = [baseUrl substringFromIndex:range.location + 1];
    
    if ([typeStr isEqualToString:@"shop_showstorelist"]) {
        //活动直播员列表
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"&"];
        NSArray *arr = [self strReturnArr:superArr[0] componentsStr:@"="];
        NSArray *arr1 = [self strReturnArr:superArr[1] componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_showstorelist",
                 arr[0]:arr[1],
                 arr1[0]:arr1[1]
                 };
    }else if ([typeStr isEqualToString:@"shop_seller"]){
        //直播组详情
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_seller",
                 superArr[0]:superArr[1]
                 };
    }else if ([typeStr isEqualToString:@"shop_goods"]){
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_goods",
                 superArr[0]:superArr[1]
                 };
    }else if ([typeStr isEqualToString:@"shop_willactivitydetail"]){
        // 预热详情页
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_willactivitydetail",
                 superArr[0]:superArr[1]
                 };
    }else if ([typeStr isEqualToString:@"shop_livingactivitydetail"]){
        //正在直播
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"&"];
        NSArray *arr = [self strReturnArr:superArr[0] componentsStr:@"="];
        NSArray *arr1 = [self strReturnArr:superArr[1] componentsStr:@"="];
        NSArray *arr2 = [self strReturnArr:superArr[2] componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_livingactivitydetail",
                 arr[0]:arr[1],
                 arr1[0]:arr1[1],
                 arr2[0]:arr2[1],
                 };
    }else if ([typeStr isEqualToString:@"shop_endactivitydetail"]){
        //结束
        NSArray *superArr = [self strReturnArr:parameter componentsStr:@"&"];
        NSArray *arr = [self strReturnArr:superArr[0] componentsStr:@"="];
        NSArray *arr1 = [self strReturnArr:superArr[1] componentsStr:@"="];
        return @{
                 @"ShareState":@"shop_endactivitydetail",
                 arr[0]:arr[1],
                 arr1[0]:arr1[1]
                 };
    }else{
        
    }
    return @{};
}


- (void)pushPage:(NSDictionary *)shareDic{
    NSString *tyStr = shareDic[@"ShareState"];
    if ([tyStr isEqualToString:@"shop_showstorelist"]) {
        LiveListVC *live = [[LiveListVC alloc]init];
        live.activity_id = shareDic[@"activity_id"];
        live.ac_state = shareDic[@"ac_state"];
        live.hidesBottomBarWhenPushed = YES;
        [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:live animated:YES];
    }else if ([tyStr isEqualToString:@"shop_seller"]){
        LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
        live.store_id = shareDic[@"seller_id"];
        live.hidesBottomBarWhenPushed = YES;
        [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:live animated:YES];

    }else if ([tyStr isEqualToString:@"shop_goods"]){
        DiscoverDetailVC *dis = [[DiscoverDetailVC alloc]init];
        dis.strace_id = shareDic[@"goods_straceid"];
        dis.typeStr = @"淘好货";
        dis.hidesBottomBarWhenPushed = YES;
        [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:dis animated:YES];
    }else if ([tyStr isEqualToString:@"shop_willactivitydetail"]){
        PreheatingVC *pre = [[PreheatingVC alloc]init];
        pre.liveId = shareDic[@"live_id"];
        pre.hidesBottomBarWhenPushed = YES;
        [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:pre animated:YES];
    }else if ([tyStr isEqualToString:@"shop_livingactivitydetail"]){
        NSString *type = shareDic[@"type"];
        if ([type isEqualToString:@"0"]) {
            PhotoLivingVC *pVC = [PhotoLivingVC new];
            pVC.liveId = shareDic[@"live_id"];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:pVC animated:YES];
        }else{
            
            NSString *imgUrl = [shareDic[@"image"] stringByRemovingPercentEncoding];
            
            [[SDWebImageDownloader sharedDownloader]
             downloadImageWithURL:[NSURL URLWithString:imgUrl]
             options:SDWebImageDownloaderUseNSURLCache
             progress:nil
             completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                 if (finished && !error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         LivingVC *lVC = [LivingVC new];
                         lVC.liveId = shareDic[@"live_id"];
                         lVC.playerPHImg = image;
                         lVC.hidesBottomBarWhenPushed = YES;
                         [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:lVC animated:YES];
                         [YPC_Tools dismissHud];
                     });
                 }else {
                     [YPC_Tools showSvpHudError:@"加载失败, 请重试"];
                 }
             }];
        }
    }else if ([tyStr isEqualToString:@"shop_endactivitydetail"]){
        NSString *type = shareDic[@"type"];
        if ([type isEqualToString:@"0"]) {
            PhotoLivingVC *pVC = [PhotoLivingVC new];
            pVC.liveId = shareDic[@"live_id"];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:pVC animated:YES];
        }else{
            VideoPlayerVC *vVC = [VideoPlayerVC new];
            vVC.liveId = shareDic[@"live_id"];
            vVC.hidesBottomBarWhenPushed = YES;
            [self.window.rootViewController.childViewControllers[0].rt_navigationController pushViewController:vVC animated:YES];
        }
    }
}

- (NSArray *)strReturnArr:(NSString *)str componentsStr:(NSString *)componentsStr{
   return  [str componentsSeparatedByString:componentsStr];
}

- (void)didReceiveAccountDidOutOfDate
{
//    LoginVC *logVC = [LoginVC new];
//    [self.window.rootViewController presentViewController:logVC animated:YES completion:nil];
}



@end

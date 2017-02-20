//
//  YPCRequestCenter.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/5.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "YPCRequestCenter.h"
#import "JPUSHService.h"
#import "LoginVC.h"
#import <SAMKeychain.h>

@implementation YPCRequestCenter

+ (instancetype)shareInstance
{
    
    static YPCRequestCenter* _instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YPCRequestCenter alloc] init];
         [NotificationCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    });
    return _instance;
}

- (AFNetworkReachabilityManager *)manager
{
    if (_manager) {
        return _manager;
    }
    _manager = [AFNetworkReachabilityManager sharedManager];
    return _manager;
}

+ (BOOL)isVaildNetwork
{
    if ([YPCRequestCenter shareInstance].manager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown || [YPCRequestCenter shareInstance].manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }else {
        return YES;
    }
}

+ (CurrentNetWorkType)getCurrentNetworkType
{
    switch ([YPCRequestCenter shareInstance].manager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return CurrentNetWorkUnknown;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return CurrentNetWork3G4G;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return CurrentNetWorkWifi;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return CurrentNetWorkNotReachable;
            break;
            
        default:
            break;
    }
    return CurrentNetWorkNotReachable;
}

+ (NSDictionary *)getUserInfo
{
    if ([YPCRequestCenter shareInstance].sID && [YPCRequestCenter shareInstance].uID) {
        
        NSDictionary *info = @{
                               @"session" : @{
                                       @"sid" : [YPCRequestCenter shareInstance].sID,
                                       @"uid" : [YPCRequestCenter shareInstance].uID
                                       }
                               };
        return info;
        
    }else {
//        NSLog(@"error : sID nil uID nil");
        NSDictionary *info = @{
                               @"session" : @{
                                       @"sid" : @"0",
                                       @"uid" : @"0"
                                       }
                               };
        return info;
    }
    
}

+ (NSDictionary *)getUserInfoAppendDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *tempDic = [[YPCRequestCenter getUserInfo] mutableCopy];
    [tempDic setValuesForKeysWithDictionary:dic];
    return tempDic;
}

+ (void)cacheUserKeychainWithSID:(NSString *)sid
{
    [YPCRequestCenter setUserLogin];
    [UserDefaults synchronize];
    [SAMKeychain setPassword:sid forService:KEY_KEYCHAIN_SERVICE account:KEY_KEYCHAIN_NAME];
}

+ (void)removeCacheUserKeychain
{
    [SAMKeychain deletePasswordForService:KEY_KEYCHAIN_SERVICE account:KEY_KEYCHAIN_NAME];
    [self setUserLogout];
    [YPCRequestCenter shareInstance].model = nil;
    [YPCRequestCenter shareInstance].uID = nil;
    [YPCRequestCenter shareInstance].sID = nil;
    [YPCRequestCenter shareInstance].kUnReadMesCount = nil;
    [YPCRequestCenter shareInstance].kShopingCarCount = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [UserDefaults synchronize];
}

+ (void)setUserInfoWithResponse:(id)response
{
    [YPCRequestCenter shareInstance].sID = [response valueForKeyPath:@"data.session.sid"];
    [YPCRequestCenter shareInstance].uID = [response valueForKeyPath:@"data.session.uid"];
    [YPCRequestCenter shareInstance].model = [UserModel mj_objectWithKeyValues:response[@"data"][@"user"]];
}

+ (BOOL)isLogin
{
    if ([[UserDefaults objectForKey:kUserIsLogin] isEqual:@1]) {
        return YES;
    }else {
        return NO;
    }
}

+ (void)isLoginAndPresentLoginVC:(UIViewController *)vc
                         success:(YPCVoidBlock)success
{
    if (![self isLogin]) {
        LoginVC *login = [LoginVC new];
        [login setSuccessLoginBlock:^{
            success();
        }];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:login];
        login.navigationController.navigationBar.hidden = YES;
        [vc presentViewController:loginNav animated:YES completion:nil];
    }else {
        success();
    }
}

+ (void)setUserLogin
{
    [UserDefaults setObject:@1 forKey:kUserIsLogin];
    [YPCRequestCenter shareInstance].kShopingCarCount = [YPCRequestCenter shareInstance].model.card_num;
}

+ (void)setUserLogout
{
    [UserDefaults setObject:@0 forKey:kUserIsLogin];
}

+ (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    if ([dic[@"content_type"] integerValue] == 1) {
        switch ([dic[@"extras"][@"strace_type"] integerValue]) {
                
            case 1:
                [NotificationCenter postNotificationName:@"comment" object:dic];//预热贴
                break;
            case 2:
                [NotificationCenter postNotificationName:@"comment" object:dic];//商品贴
                break;
                
            default:
                break;
        }
    }else if([dic[@"content_type"] integerValue] == 2){
        switch ([dic[@"extras"][@"strace_type"] integerValue]) {
                
            case 2:
                [NotificationCenter postNotificationName:@"comment" object:dic];//预热贴
                break;
            case 4:
                [NotificationCenter postNotificationName:@"comment" object:dic];//商品贴
                break;
                
            default:
                break;
        }
    }
   
}
@end

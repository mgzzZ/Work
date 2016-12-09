//
//  MineViewController.h
//  TaoFactory_Seller
//
//  Created by YPC on 16/9/17.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "LCCKUser.h"
#import "LeanChatFactory.h"
#import <objc/runtime.h>
#import "LoginVC.h"
#import "AppDelegate.h"
#import "HomeVC.h"

@interface LeanChatFactory ()

@end

@implementation LeanChatFactory

#pragma -
#pragma mark - init Method

/**
 *  初始化
 */
- (void)leanCloudInit {
    [self lcck_setting];
}
- (void)lcck_setting {
    [self lcck_setupAppInfo];
    //设置用户体系
    [self lcck_setFetchProfiles];
    //设置聊天列表
    [self lcck_setupConversationsList];
    //设置聊天
    [self lcck_setupConversation];
    //设置重新连接
    [self lcck_setupForceReconect];
    // 接收到消息处理
    [self lcck_setupNotification];
    
    [self lcck_setupFilterMessage];
    
    [NotificationCenter addObserver:self selector:@selector(customMessageReceive:) name:LCCKNotificationCustomTransientMessageReceived object:nil];
    // 设置角标
    [self lcck_setupBadge];
}

- (void)customMessageReceive:(NSNotification *)object
{
    AVIMTypedMessage *message = object.object[LCCKDidReceiveCustomMessageUserInfoMessageKey];
    if (message.mediaType == 1) { // 订单消息
        
    }else if (message.mediaType == 2) { // 弹幕消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.attributes];
        if (message.text) {
            [dic setValuesForKeysWithDictionary:@{@"message" : message.text}];
            [NotificationCenter postNotificationName:DidReceiveDanmakuFormLeanCloudCusstomMessage object:dic];
        }
    }else if (message.mediaType == 3) { //直播间点赞消息
        [NotificationCenter postNotificationName:DidReceiveLivingLikeFormLeanCloudCusstomMessage object:nil];
    }
}

- (void)lcck_setupConversation {
    //设置打开会话的操作
    //    [self lcck_setupOpenConversation];
    [self lcck_setupConversationInvalidedHandler];
    //    [self lcck_setupLoadLatestMessages];
    //点击图片，放大查看的设置。不设置则使用默认方式
    //[self lcck_setupPreviewImageMessage];
    //    [self lcck_setupLongPressMessage];
    
}
- (void)lcck_setupConversationsList
{
    //设置最近联系人列表cell的操作
    [self lcck_setupConversationsCellOperation];
}

#pragma mark - SDK Life Control

+ (void)invokeThisMethodInDidFinishLaunching {
    // 如果APP是在国外使用，开启北美节点
    // [AVOSCloud setServiceRegion:AVServiceRegionUS];
    // 启用未读消息
    [AVIMClient setUserOptions:@{ AVIMUserOptionUseUnread : @(YES) }];
    [AVOSCloud registerForRemoteNotification];
    [AVIMClient setTimeoutIntervalInSeconds:20];
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
    [LCCKInputViewPluginLocation registerSubclass];
}

+ (void)invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)invokeThisMethodBeforeLogoutSuccess:(LCCKVoidBlock)success failed:(LCCKErrorBlock)failed {
    //    [AVOSCloudIM handleRemoteNotificationsWithDeviceToken:nil];
    [[LCChatKit sharedInstance] removeAllCachedProfiles];
    [[LCChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self lcck_clearLocalClientInfo];
//            [LCCKUtil showNotificationWithTitle:@"退出成功"
//                                       subtitle:nil
//                                           type:LCCKMessageNotificationTypeSuccess];
            !success ?: success();
        } else {
//            [LCCKUtil showNotificationWithTitle:@"退出失败"
//                                       subtitle:nil
//                                           type:LCCKMessageNotificationTypeError];
            !failed ?: failed(error);
        }
    }];
}

+ (void)saveLocalClientInfo:(NSString *)clientId {
    // 在系统偏好保存信息
    NSUserDefaults *defaultsSet = [NSUserDefaults standardUserDefaults];
    [defaultsSet setObject:clientId forKey:@"LCCK_KEY_USERID"];
    [defaultsSet synchronize];
}

+ (void)invokeThisMethodAfterLoginSuccessWithClientId:(NSString *)clientId
                                              success:(LCCKVoidBlock)success
                                               failed:(LCCKErrorBlock)failed {
    [YPCNetworking postWithUrl:@"common/user/getnoreadnewscount"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"type" : @"1"}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [[self sharedInstance] leanCloudInit];
                               [[LCChatKit sharedInstance] openWithClientId:clientId callback:^(BOOL succeeded, NSError *error) {
                                   if (succeeded) {
                                       [self saveLocalClientInfo:clientId];
                                       !success ?: success();
                                       [self getUnreadCountWithIineUnreadCount:[response[@"data"][@"noreadcount"] integerValue]];
                                   } else {
                                       !failed ?: failed(error);
                                   }
                               }];
                           }
                       } fail:^(NSError *error) {
                           !failed ?: failed(error);
                       }];
}

+ (void)invokeThisMethodInApplication:(UIApplication *)application
         didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    } else {
        /*!
         *  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
         {
         aps =     {
         alert = "lcckkit : sdfsdf";
         badge = 4;
         sound = default;
         };
         convid = 55bae86300b0efdcbe3e742e;
         }
         */
        [[LCChatKit sharedInstance] didReceiveRemoteNotification:userInfo];
    }
}

+ (void)invokeThisMethodInApplicationWillResignActive:(UIApplication *)application {
    [[LCChatKit sharedInstance] syncBadge];
}

+ (void)invokeThisMethodInApplicationWillTerminate:(UIApplication *)application {
    [[LCChatKit sharedInstance] syncBadge];
}

#pragma mark - leanCloud的app信息设置
- (void)lcck_setupAppInfo {
    
//    [LCChatKit setAllLogsEnabled:YES];
//    [[LCChatKit sharedInstance] setUseDevPushCerticate:YES];
    [LCChatKit setAppId:LeanCloudAppId appKey:LeanCloudAppKey];
}

- (void)lcck_setFetchProfiles {
    
    [[LCChatKit sharedInstance] setFetchProfilesBlock:^(NSArray<NSString *> *userIds,
                                                        LCCKFetchProfilesCompletionHandler completionHandler) {
        if (userIds.count == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"User ids is nil";
            NSDictionary *errorInfo = @{
                                        @"code":@(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:code
                                             userInfo:errorInfo];
            
            !completionHandler ?: completionHandler(nil, error);
            return;
        }
    
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:userIds.count];
        
        [userIds enumerateObjectsUsingBlock:^(NSString *_Nonnull clientId, NSUInteger idx,
                                              BOOL *_Nonnull stop) {
            
            
            [YPCNetworking postWithUrl:@"merchant/user/infobylean"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"client": clientId}]
                               success:^(id response) {
                                   
                                   NSNumber *num = [NSNumber numberWithInteger:0];
                                   if (response[@"status"][@"succeed"] != num) {
                                       LCCKUser *user_ = [LCCKUser userWithUserId:response[@"data"][@"member_id"]
                                                                             name:response[@"data"][@"member_truename"]
                                                                        avatarURL:response[@"data"][@"member_avatar"]
                                                                         clientId:clientId];
                                       [users addObject:user_];
                                       !completionHandler ?: completionHandler([users copy], nil);
                                   }
                                   
                               } fail:^(NSError *error) {
                                   LCCKUser *user_ = [LCCKUser userWithClientId:[LCChatKit sharedInstance].clientId];
                                   [users addObject:user_];
                                   !completionHandler ?: completionHandler([users copy], nil);
                               }];
        }];
    }];
}

/**
 *  设置联系人列表页面中，对cell的操作回调
 */
- (void)lcck_setupConversationsCellOperation {
    //选中某个对话后的回调,设置事件响应函数
    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(
                                                                         NSIndexPath *indexPath, AVIMConversation *conversation,
                                                                         LCCKConversationListViewController *controller) {
        
        [YPCNetworking postWithUrl:@"merchant/user/infobylean"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"client": conversation.members.lastObject}]
                           success:^(id response) {
                               NSNumber *num = [NSNumber numberWithInteger:0];
                               if (response[@"status"][@"succeed"] != num) {
                                   
                                   LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithConversationId:conversation.conversationId];
                                   conversationViewController.enableAutoJoin = YES;
                                   conversationViewController.disableTitleAutoConfig = YES;
                                   [controller.navigationController pushViewController:conversationViewController animated:YES];
                                   
                                   [conversationViewController setViewDidLoadBlock:^(__kindof LCCKBaseViewController *viewController) {
                                       
                                       viewController.navigationController.navigationBar.barTintColor = [Color colorWithHex:@"#3B3B3B"];
                                       viewController.navigationController.navigationBar.translucent = YES;
                                       [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:BoldFont(18),NSForegroundColorAttributeName:[UIColor whiteColor]}];
                                       viewController.title = [(NSDictionary *)response[@"data"] safe_objectForKey:@"member_truename"];
                                       
                                       UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                       [button setImage:IMAGE(@"logon_icon_return") forState:UIControlStateNormal];
                                       [button sizeToFit];
                                       [button addTarget:self
                                                  action:@selector(naviRightAction:)
                                        forControlEvents:UIControlEventTouchUpInside];
                                       objc_setAssociatedObject(button, @"backObject", viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                       UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                                       viewController.navigationItem.leftBarButtonItem = editItem;
                                   }];
                               }
                           } fail:^(NSError *error) {
                               [YPC_Tools showSvpHudError:@"打开会话失败"];
                           }];
    }];
}
- (void)naviRightAction:(UIButton *)sender
{
     UIViewController *VC = objc_getAssociatedObject(sender, @"backObject");
    [VC.navigationController popViewControllerAnimated:YES];
}

/**
 *  强制重连
 */
- (void)lcck_setupForceReconect {
    
    [[LCChatKit sharedInstance] setForceReconnectSessionBlock:^(
                                                                NSError *aError, BOOL granted,
                                                                __kindof UIViewController *viewController,
                                                                LCCKReconnectSessionCompletionHandler completionHandler) {
        BOOL isSingleSignOnOffline = (aError.code == 4111);
        // - 用户允许重连请求，发起重连或强制登录
        if (granted == YES) {
            BOOL force = NO;
            NSString *title = @"正在重连聊天服务...";
            if (isSingleSignOnOffline) {
                force = YES;
                title = @"正在强制登录...";
            }
            [YPC_Tools showSvpHud:title];
            [[LCChatKit sharedInstance] openWithClientId:[LCChatKit sharedInstance].clientId
                                                           force:force
                                                        callback:^(BOOL succeeded, NSError *error) {
                                                            [YPC_Tools dismissHud];
                                                            !completionHandler ?: completionHandler(succeeded, error);
                                                        }];
            return;
        }
        
        // 用户拒绝了重连请求
        // - 退回登录页面
        [[self class] lcck_clearLocalClientInfo];
        [YPCRequestCenter setUserLogout];
        
        // - 显示返回信息
        NSInteger code = 0;
        NSString *errorReasonText = @"not granted";
        NSDictionary *errorInfo = @{
                                    @"code" : @(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error =
        [NSError errorWithDomain:NSStringFromClass([self class]) code:code userInfo:errorInfo];
        !completionHandler ?: completionHandler(NO, error);
    }];
}

/**
 *  筛选消息的设置
 */
- (void)lcck_setupFilterMessage {
    //这里演示如何筛选新的消息记录，以及新接收到的消息，以群定向消息为例：
    [[LCChatKit sharedInstance] setFilterMessagesBlock:^(AVIMConversation *conversation,
                                                         NSArray<AVIMTypedMessage *> *messages,
                                                         LCCKFilterMessagesCompletionHandler completionHandler) {
        if (messages.lastObject.mediaType == 2) {
            return;
        }
        if (messages.lastObject.mediaType == 3) {
            return;
        }
        if (conversation.lcck_type == LCCKConversationTypeSingle) {
            completionHandler(messages, nil);
            return;
        }
    }];
}

/**
 *  设置收到ChatKit的通知处理
 */
- (void)lcck_setupNotification {
    [[LCChatKit sharedInstance] setShowNotificationBlock:^(UIViewController *viewController, NSString *title,
                                                           NSString *subtitle, LCCKMessageNotificationType type) {

    }];
}

/**
 *  设置badge角标
 */
+ (void)getUnreadCountWithIineUnreadCount:(NSInteger)lineUnreadCount
{
      [[LCCKConversationListService sharedInstance] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
          if (!error) {
              NSInteger totalCount = lineUnreadCount + totalUnreadCount;
              if (totalCount > 0) {
                  NSString *badgeValue = [NSString stringWithFormat:@"%ld", (long)totalCount];
                  if (totalCount > 99) {
                      badgeValue = LCCKBadgeTextForNumberGreaterThanLimit;
                  }
                  [YPCRequestCenter shareInstance].kUnReadMesCount = badgeValue;
                  [HomeVC shareInstance].unReadMesCount = badgeValue;
              } else {
                  [HomeVC shareInstance].unReadMesCount = nil;
              }
              
          }
      }];
}

/**
 *  设置Badge
 */
- (void)lcck_setupBadge {
    //    TabBar样式，自动设置。如果不是TabBar样式，请实现该 Blcok 来设置 Badge 红标。
    [[LCChatKit sharedInstance] setMarkBadgeWithTotalUnreadCountBlock:^(
                                                                        NSInteger totalUnreadCount, UIViewController *controller) {
        if (totalUnreadCount > 0) {
            NSString *badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
            if (totalUnreadCount > 99) {
                badgeValue = LCCKBadgeTextForNumberGreaterThanLimit;
            }
            [YPCRequestCenter shareInstance].kUnReadMesCount = badgeValue;
            [HomeVC shareInstance].unReadMesCount = badgeValue;
        } else {
            [HomeVC shareInstance].unReadMesCount = nil;
        }
    }];
}


/**
 *  设置会话出错的回调处理
 */
- (void)lcck_setupConversationInvalidedHandler {
    [[LCChatKit sharedInstance] setConversationInvalidedHandler:^(NSString *conversationId,
                                                                  LCCKConversationViewController *conversationController,
                                                                  id<LCCKUserDelegate> administrator, NSError *error) {
        //错误码参考：https://leancloud.cn/docs/realtime_v2.html#%E4%BA%91%E7%AB%AF%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E
        
        [YPC_Tools showSvpHudError:@"打开对话失败(clientID错误)"];
    }];
}

#pragma mark -
#pragma mark - Private Methods

#pragma mark 清除Client信息
+ (void)lcck_clearLocalClientInfo {
    // 在系统偏好保存信息
    NSUserDefaults *defaultsSet = [NSUserDefaults standardUserDefaults];
    [defaultsSet setObject:nil forKey:@"LCCK_KEY_USERID"];
    [defaultsSet synchronize];
}

/**
 * create a singleton instance of LCChatKitExample
 */
+ (instancetype)sharedInstance {
    static LeanChatFactory *_leanChatFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _leanChatFactory = [[self alloc] init];
    });
    return _leanChatFactory;
}

@end

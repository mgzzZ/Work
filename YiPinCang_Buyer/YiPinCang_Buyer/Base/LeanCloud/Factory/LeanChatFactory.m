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
#import "LCPushMessageVC.h"

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
    if (message.mediaType == LeanCloudCustomMessageDanmu) { // 弹幕消息
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.attributes];
        if (message.text) {
            [dic setValuesForKeysWithDictionary:@{@"message" : message.text}];
            [NotificationCenter postNotificationName:DidReceiveDanmakuFormLeanCloudCusstomMessage object:dic];
        }
    }else if (message.mediaType == LeanCloudCustomMessageLivingLike) { // 直播间点赞消息
        [NotificationCenter postNotificationName:DidReceiveLivingLikeFormLeanCloudCusstomMessage object:nil];
    }else if (message.mediaType == LeanCloudCustomMessageGoodsTop) {  // 直播间商品顶置
        [NotificationCenter postNotificationName:DidReceiveLivingGoodsTopFormLeanCloudCusstomMessage object:message.attributes];
    }else if (message.mediaType == LeanCloudCustomMessageGoodsIssue) { // 直播间商品发布
        [NotificationCenter postNotificationName:DidReceiveLivingGoodsIssueLeanCloudCusstomMessage object:message.attributes];
    }else if (message.mediaType == LeanCloudCustomMessageLivingPause) { // 直播间暂停
        [NotificationCenter postNotificationName:DidReceiveLivingLivingPauseLeanCloudCusstomMessage object:nil];
    }else if (message.mediaType == LeanCloudCustomMessageLivingStop) { // 直播间停止
        [NotificationCenter postNotificationName:DidReceiveLivingLivingStopLeanCloudCusstomMessage object:nil];
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
    //设置编辑按钮
    [self lcck_setupConversationEditActionForConversationList];
}

#pragma mark - SDK Life Control

+ (void)invokeThisMethodInDidFinishLaunching {
    // 启用未读消息
    [AVIMClient setUserOptions:@{ AVIMUserOptionUseUnread : @(YES) }];
    [AVIMClient setTimeoutIntervalInSeconds:20];
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
//    [LCCKInputViewPluginLocation registerSubclass];
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
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"common/user/getnoreadnewscount"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"type" : @"1"}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [[weakSelf sharedInstance] leanCloudInit];
                               [[LCChatKit sharedInstance] openWithClientId:clientId callback:^(BOOL succeeded, NSError *error) {
                                   if (succeeded) {
                                       [weakSelf getUnreadCountWithIineUnreadCount:[response[@"data"][@"noreadcount"] integerValue] AndCallBack:^(BOOL succeeded, NSError *error) {
                                           if (succeeded) {
                                               [weakSelf saveLocalClientInfo:clientId];
                                               !success ?: success();
                                           }else {
                                                !failed ?: failed(error);
                                           }
                                       }];
                                   } else {
                                       !failed ?: failed(error);
                                   }
                               }];
                           }else {
                               !failed ?: failed([NSError new]);
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
                                   if ([response[@"status"][@"succeed"] integerValue] != 0 && ![response[@"data"][@"hx_uname"] isEqual:[NSNull null]]  && ![response[@"data"][@"member_id"] isEqual:[NSNull null]]  && ![response[@"data"][@"member_truename"] isEqual:[NSNull null]]) {
                                       LCCKUser *user_ = [LCCKUser userWithUserId:response[@"data"][@"member_id"]
                                                                             name:response[@"data"][@"member_truename"]
                                                                        avatarURL:response[@"data"][@"member_avatar"]
                                                                         clientId:clientId];
                                       [users addObject:user_];
                                       !completionHandler ?: completionHandler([users copy], nil);
                                   }else {
                                       LCCKUser *user = [LCCKUser userWithClientId:clientId];
                                       [users addObject:user];
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
        if (conversation.members.count > 0) {            
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
                                           if (![response[@"data"][@"member_truename"] isEqual:[NSNull null]]) {
                                               viewController.title = [(NSDictionary *)response[@"data"] safe_objectForKey:@"member_truename"];
                                           }else {
                                               viewController.title = conversation.members.lastObject;
                                           }
                                           
                                           UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                           __weak __typeof(button) weakBtn = button;
                                           [weakBtn setImage:IMAGE(@"logon_icon_return") forState:UIControlStateNormal];
                                           [weakBtn sizeToFit];
                                           [weakBtn addTarget:self
                                                      action:@selector(naviRightAction:)
                                            forControlEvents:UIControlEventTouchUpInside];
                                           objc_setAssociatedObject(weakBtn, @"backObject", viewController, OBJC_ASSOCIATION_ASSIGN);
                                           UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:weakBtn];
                                           __weak __typeof(editItem) weakItem = editItem;
                                           viewController.navigationItem.leftBarButtonItem = weakItem;
                                       }];
                                       
                                       [conversationViewController setViewControllerWillDeallocBlock:^(__kindof LCCKBaseViewController *viewController) {
                                           YPCAppLog(@"%@...Dealloc", NSStringFromClass([viewController class]));
                                       }];
                                   }
                               } fail:^(NSError *error) {
                                   [YPC_Tools showSvpHudError:@"打开会话失败"];
                               }];
        }else {
            if ([[conversation.attributes safe_objectForKey:@"r_type"] integerValue] == 1) {
                // 系统消息
                LCPushMessageVC *pushMesVC = [LCPushMessageVC new];
                pushMesVC.messageType = LCMessageTypeSystem;
                [controller.navigationController pushViewController:pushMesVC animated:YES];
                [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversation.conversationId];
            }
            if ([[conversation.attributes safe_objectForKey:@"r_type"] integerValue] == 2) {
                // 活动提醒
                LCPushMessageVC *pushMesVC = [LCPushMessageVC new];
                pushMesVC.messageType = LCMessageTypeActivity;
                [controller.navigationController pushViewController:pushMesVC animated:YES];
                [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversation.conversationId];
            }
            if ([[conversation.attributes safe_objectForKey:@"r_type"] integerValue] == 4) {
                // 订单消息
                LCPushMessageVC *pushMesVC = [LCPushMessageVC new];
                pushMesVC.messageType = LCMessageTypeOrder;
                [controller.navigationController pushViewController:pushMesVC animated:YES];
                [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversation.conversationId];
            }
        }
    }];
}
- (void)naviRightAction:(UIButton *)sender
{
     UIViewController *VC = objc_getAssociatedObject(sender, @"backObject");
    [VC.navigationController popViewControllerAnimated:YES];
}

- (void)lcck_setupConversationEditActionForConversationList {
    // 自定义Cell菜单
    [[LCChatKit sharedInstance] setConversationEditActionBlock:^NSArray *(
                                                                          NSIndexPath *indexPath, NSArray<UITableViewRowAction *> *editActions,
                                                                          AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        return [self lcck_ConversationEditActionAtIndexPath:indexPath
                                                      conversation:conversation
                                                        controller:controller];
    }];
}

- (NSArray *)lcck_ConversationEditActionAtIndexPath:(NSIndexPath *)indexPath
                                              conversation:(AVIMConversation *)conversation
                                                controller:(LCCKConversationListViewController *)controller {
    // 如果需要自定义其他会话的菜单，在此编辑
    return [self lcck_rightButtonsAtIndexPath:indexPath conversation:conversation controller:controller];
}

- (NSArray *)lcck_rightButtonsAtIndexPath:(NSIndexPath *)indexPath
                             conversation:(AVIMConversation *)conversation
                               controller:(LCCKConversationListViewController *)controller {
    NSString *title = nil;
    UITableViewRowActionHandler handler = nil;
    [self lcck_markReadStatusAtIndexPath:indexPath
                                   title:&title
                                  handle:&handler
                            conversation:conversation
                              controller:controller];
    UITableViewRowAction *actionItemMore =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:title
                                     handler:handler];
    actionItemMore.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    UITableViewRowAction *actionItemDelete = [UITableViewRowAction
                                              rowActionWithStyle:UITableViewRowActionStyleDefault
                                              title:LCCKLocalizedStrings(@"Delete")
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  [[LCChatKit sharedInstance] deleteRecentConversationWithConversationId:conversation.conversationId];
                                              }];
    return @[ actionItemDelete, actionItemMore];
}

typedef void (^UITableViewRowActionHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

- (void)lcck_markReadStatusAtIndexPath:(NSIndexPath *)indexPath
                                 title:(NSString **)title
                                handle:(UITableViewRowActionHandler *)handler
                          conversation:(AVIMConversation *)conversation
                            controller:(LCCKConversationListViewController *)controller {
    NSString *conversationId = conversation.conversationId;
    if (conversation.lcck_unreadCount > 0) {
        if (*title == nil) {
            *title = @"标记为已读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversationId];
        };
    } else {
        if (*title == nil) {
            *title = @"标记为未读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] increaseUnreadCountWithConversationId:conversationId];
        };
    }
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
        
        AVIMTypedMessage *message = messages.lastObject;
        NSLog(@"%hhd", message.mediaType);
        if (message.mediaType == LeanCloudCustomMessageDanmu || message.mediaType == LeanCloudCustomMessageLivingLike || message.mediaType == LeanCloudCustomMessageLivingLike || message.mediaType == LeanCloudCustomMessageGoodsTop || message.mediaType == LeanCloudCustomMessageGoodsIssue || message.mediaType == LeanCloudCustomMessageLivingPause || message.mediaType == LeanCloudCustomMessageLivingStop) {
            return ;
        }
        if (conversation.lcck_type == LCCKConversationTypeSingle || conversation.lcck_type == LCCKConversationTypeGroup) {
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
+ (void)getUnreadCountWithIineUnreadCount:(NSInteger)lineUnreadCount AndCallBack:(LCCKBooleanResultBlock)callBack
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
              } else {
                  [YPCRequestCenter shareInstance].kUnReadMesCount = @"";
              }
              !callBack ?: callBack(YES, nil);
          }else {
              !callBack ?: callBack(NO, error);
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
            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeValue.integerValue;
        } else {
            [YPCRequestCenter shareInstance].kUnReadMesCount = @"";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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

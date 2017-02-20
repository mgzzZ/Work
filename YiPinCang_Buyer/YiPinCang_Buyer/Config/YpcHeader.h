//
//  YpcHeader.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#ifndef YpcHeader_h
#define YpcHeader_h

//===================== frame
#define ScreenWidth                [UIScreen mainScreen].bounds.size.width
#define ScreenHeight               [UIScreen mainScreen].bounds.size.height
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen mainScreen].bounds.size.width == 320)
#define iPhone6 ([UIScreen mainScreen].bounds.size.width == 375)
#define iPhone6P ([UIScreen mainScreen].bounds.size.width == 414)
#define kWidth(R) (R)*(ScreenWidth)/375
#define kHeight(R) (iPhone4?((R)*(ScreenHeight)/480):((R)*(ScreenHeight)/667))
#define kScreen [UIScreen mainScreen].bounds
//===================== 代码简化
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define IMAGE(img) [UIImage imageNamed:img]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define RGB(r,g,b,a)                [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

// ===================== 字体
#define LightFont(fontsize)    [UIFont fontWithName:@"STHeitiSC-Light" size:fontsize]
#define BoldFont(fontsize)     [UIFont fontWithName:@"STHeitiSC-Medium" size:fontsize]
#define YPCPFFont(fontsize)     [UIFont fontWithName:@"PingFangSC-Regular" size:fontsize]
//==================== improt
#import "YPCNetworking.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <FMDB.h>
#import <SVProgressHUD.h>
#import "NSString+helpers.h"
#import "UIImage+helpers.h"
#import "UIImageView+TranssitionNew.h"
#import "UILabel+height.h"
#import "UIView+Addtions.h"
#import "UIView+BadgeValue.h"
#import "NSDictionary+Safety.h"
#import "Color.h"
#import "YPC_Tools.h"
#import "Constants.h"
#import <QiniuSDK.h>
#import <UMSocialCore/UMSocialCore.h>
#import <LGAlertView.h>
#import "YPCRequestCenter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LCChatKit.h>
#import <SDAutoLayout.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <UIScrollView+EmptyDataSet.h>
#import <POP.h>
#import "UIControl+recurClick.h"
#import <YYText.h>
#import <YYWebImage.h>
#import <RTRootNavigationController.h>
#import "UINavigationBar+BackgroundColor.h"
#import "YPCRefreshHeader.h"
#import <UShareUI/UShareUI.h>
#import "OriginalPriceLab.h"
#import "YPCShare.h"

//Documents文件夹的路径
#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

//=================== LeanCloud
#define LeanCloudAppId @"HoqYfXgakVmiwQjAUe9qRXnW-gzGzoHsz"
#define LeanCloudAppKey @"lOrkWTAg8IqCEsrL4s8tM212"

//=================== NotificationCenter
#define LeanCloudNotReadMessageCount                                @"LeanCloudNotReadMessageCount" // 程序运行请求checkinfo, 通知首页显示消息未读数
#define DidReceiveDanmakuFormLeanCloudCusstomMessage                @"didReceiveDanmakuFormLeanCloudCusstomMessage" // 收到弹幕消息通知
#define DidReceiveLivingLikeFormLeanCloudCusstomMessage             @"didReceiveLivingLikeFormLeanCloudCusstomMessage" // 收到leancloud点赞通知
#define DidReceiveLivingGoodsTopFormLeanCloudCusstomMessage         @"didReceiveLivingGoodsTopFormLeanCloudCusstomMessage" // 收到leancloud点赞通知
#define DidReceiveLivingGoodsIssueLeanCloudCusstomMessage           @"didReceiveLivingGoodsIssueLeanCloudCusstomMessage" // 收到leancloud点赞通知
#define DidReceiveLivingLivingPauseLeanCloudCusstomMessage          @"didReceiveLivingLivingPauseLeanCloudCusstomMessage" // 收到直播暂停通知
#define DidReceiveLivingLivingStopLeanCloudCusstomMessage           @"didReceiveLivingLivingStopLeanCloudCusstomMessage" // 收到直播停止通知

//通知宏定义
#define PaySuccess @"PaySuccess"
#define PayError @"PayError"
#define WechatPay @"WechatPay"
//=================== UserDefault
#define kUserSession        @"userSession"
#define kUserIsLogin        @"kUserIsLogin"

//=================== 占位图
#define YPCImagePlaceMainHomeHolder                 [UIImage imageNamed:@"homepage_live_zhanweitu"]
#define YPCImagePlaceHolder                         [UIImage imageNamed:@"live_zhanweitu"]
#define YPCImagePlaceHolderBig                      [UIImage imageNamed:@"NoneImgePlaceHoldB"]
#define YPCImagePlaceHolderSquare                   [UIImage imageNamed:@"cart_zhanweit-"]
#define YPCImagePlaceHolderBigSquare                [UIImage imageNamed:@"live_zhanweitu2"]


//===================== 友盟
#define kUMAppKey @"58199af3a40fa36dbf002a24"
#define kUMShareURL @"http://www.ypcang.com"
#define kUMWXAppID @"wxff15efaf15adc6f8"
#define kUMWXAppSecret @"83d6dbe46f84bde4cf78d0b58764d797"
#define kUMQQAppID @"1105708819"
#define kUMQQAppKey @"J9olD7s7udx8rJ0E"
#define kUMSinaAppKey @"824068500"
#define kUMSinaAppSecret @"99dd08e9f7de660cb81ddc8f90e67e7c"
#define kUMSinaCallBackURL @"http://sns.whalecloud.com/sina2/callback"
//===================== 极光
#define kJPushAppKey @"830808eb0ee65458c952891c"

#endif /* YpcHeader_h */

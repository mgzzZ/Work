//
//  YPC_Tools.h
//  TaoFactory
//
//  Created by YPC on 16/8/24.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LGAlertView.h>
#import "Constants.h"
#import <UIScrollView+EmptyDataSet.h>

@interface YPC_Tools : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

+ (instancetype)shareInstance;
@property (nonatomic, strong) LGAlertView *alertView;

+ (void)setStatusBarIsHidden:(BOOL)isHidden; //设置状态栏隐藏显示
+ (UITabBarController *)setupTabBar; //设置tabbar

/*!
 *
 *    HUB
 *
 */
+ (void)showSvpHud;
+ (void)showSvpHudWithNoneMask;
+ (void)showSvpWithPercentWithProgress:(CGFloat)progress;
+ (void)showSvpWithNoneImgHud:(NSString *)str;
+ (void)showSvpHud:(NSString *)str;
+ (void)showSvpHudWarning:(NSString *)str;
+ (void)showSvpHudError:(NSString *)str;
+ (void)showSvpHudSuccess:(NSString *)str;
+ (void)dismissHud;

/*!
 *
 *    customAlert
 *
 */
+ (void)customAlertViewWithTitle:(NSString *)title
                         Message:(NSString *)message
                       BtnTitles:(NSArray *)btnTitles
                  CancelBtnTitle:(NSString *)cancelBtnTitle
             DestructiveBtnTitle:(NSString *)destructiveBtnTitle
                   actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                   cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
              destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/*!
 *
 *    customSheet
 *
 */
+ (void)customSheetViewWithTitle:(NSString *)title
                         Message:(NSString *)message
                       BtnTitles:(NSArray *)btnTitles
                  CancelBtnTitle:(NSString *)cancelBtnTitle
             DestructiveBtnTitle:(NSString *)destructiveBtnTitle
                   actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                   cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
              destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler;

/*!
 *
 *    判断数据
 *
 */
+ (BOOL)judgeRequestAvailable:(id)response;
+ (BOOL)judgeFooterDataAvailable:(id)response; // 判断是否可以上拉加载
+ (void)judgeFooterIsHidden:(id)response WithTV:(UITableView *)tableView;

/*!
 *
 *    计算文本高度
 *
 */
+ (CGFloat)heightForText:(NSString *)text Font:(UIFont *)font Width:(CGFloat)width;

/*!
 *
 *    截取视频某一秒的图片
 *
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/*!
 *
 *    为label添加下划线
 *
 */
+ (NSAttributedString *)addLineForString:(NSString *)str;

/*!
 *
 *    时间戳转化哪年哪月哪日
 *
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString Format:(NSString *)format;

/*!
 *
 *    View获取其容器VC
 *
 */
+ (UIViewController *)getControllerWithView:(id)view;

/*!
 *
 *    时间判断活动是否过期
 *
 */
+ (BOOL)intervalFromLastDate:(NSString *)dateString;

/*!
 *
 *    时间判断活动是否过期
 *
 */
+ (UrlSechmeType)judgementUrlSechmeTypeWithUrlString:(NSString *)urlString;

/*!
 *
 *    跳转到最近会话列表页面
 *
 */
+ (void)pushConversationListViewController:(UIViewController *)vc;

/*!
 *
 *    通过leancloud打开聊天页面
 *
 */
+ (void)openConversationWithCilentId:(NSString *)clientId ViewController:(UIViewController *)vc andOrderId:(NSString *)orderId andOrderIndex:(NSString *)index;

@end

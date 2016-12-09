//
//  YPC_Tools.m
//  TaoFactory
//
//  Created by YPC on 16/8/24.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "YPC_Tools.h"
#import "HomeVC.h"
#import <RTRootNavigationController.h>

#define ClassKey   @"rootVCClassString"
#define TitleKey   @"title"
#define ImgKey     @"imageName"
#define SelImgKey  @"selectedImageName"

@implementation YPC_Tools

+ (instancetype)shareInstance
{
    static YPC_Tools* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YPC_Tools alloc] init];
    });
    return _instance;
}

+ (void)setStatusBarIsHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden];
}

+ (void)showSvpHud
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}
+ (void)showSvpHudWithNoneMask
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
}

+ (void)showSvpWithNoneImgHud:(NSString *)str
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD showInfoWithStatus:str];
}
+ (void)showSvpHud:(NSString *)str
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:str];
}
+ (void)showSvpHudWarning:(NSString *)str
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    [SVProgressHUD showInfoWithStatus:str];
}
+ (void)showSvpHudError:(NSString *)str
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    [SVProgressHUD showErrorWithStatus:str];
}
+ (void)showSvpHudSuccess:(NSString *)str
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    [SVProgressHUD showSuccessWithStatus:str];
}
+ (void)dismissHud
{ 
    [SVProgressHUD dismiss];
}

+ (void)customAlertViewWithTitle:(NSString *)title
                         Message:(NSString *)message
                       BtnTitles:(NSArray *)btnTitles
                  CancelBtnTitle:(NSString *)cancelBtnTitle
             DestructiveBtnTitle:(NSString *)destructiveBtnTitle
                   actionHandler:(void(^)(LGAlertView *alertView, NSString *title, NSUInteger index))actionHandler
                   cancelHandler:(void(^)(LGAlertView *alertView))cancelHandler
              destructiveHandler:(void(^)(LGAlertView *alertView))destructiveHandler
{
    LGAlertView *alertV = [LGAlertView alertViewWithTitle:title
                                                  message:message
                                                    style:LGAlertViewStyleAlert
                                             buttonTitles:btnTitles
                                        cancelButtonTitle:cancelBtnTitle
                                   destructiveButtonTitle:destructiveBtnTitle
                                            actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                                if (actionHandler) {
                                                    actionHandler(alertView, title, index);
                                                }
                                            }
                                            cancelHandler:^(LGAlertView *alertView) {
                                                if (cancelHandler) {
                                                    cancelHandler(alertView);
                                                }
                                            }
                                       destructiveHandler:^(LGAlertView *alertView) {
                                           if (destructiveHandler) {
                                               destructiveHandler(alertView);
                                           }
                                       }];
    alertV.coverColor = RGB(0, 0, 0, .4);
    alertV.backgroundColor = [UIColor whiteColor];
    alertV.tintColor = [UIColor whiteColor];
    
    alertV.titleFont = LightFont(16);
    alertV.titleTextColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.titleTextAlignment = NSTextAlignmentCenter;
    
    alertV.messageFont = LightFont(16);
    alertV.messageTextColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.messageTextAlignment = NSTextAlignmentCenter;
    
    alertV.buttonsFont = LightFont(16);
    alertV.buttonsHeight = 60.f;
    alertV.buttonsTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.buttonsTitleColorHighlighted = [UIColor whiteColor];
    alertV.buttonsBackgroundColor = [UIColor whiteColor];
    alertV.buttonsBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.buttonsTextAlignment = NSTextAlignmentCenter;
    
    alertV.cancelButtonFont = LightFont(16);
    alertV.cancelButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColor = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTextAlignment = NSTextAlignmentCenter;
    
    alertV.destructiveButtonFont = LightFont(16);
    alertV.destructiveButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColor = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTextAlignment = NSTextAlignmentCenter;
    
    [alertV showAnimated:YES completionHandler:nil];
}

+ (UITabBarController *)setupTabBar
{
    NSArray *childItemsArray = @[
                                 @{ClassKey  : @"HomeVC",
                                   TitleKey  : @"首页",
                                   ImgKey    : @"icon_home",
                                   SelImgKey : @"icon_homeS"},
                                 
                                 @{ClassKey  : @"DiscoverNewVC",
                                   TitleKey  : @"发现",
                                   ImgKey    : @"icon_find",
                                   SelImgKey : @"icon_findS"} ,
                                 
                                 @{ClassKey  : @"MineVC",
                                   TitleKey  : @"我",
                                   ImgKey    : @"icon_mine",
                                   SelImgKey : @"icon_mineS"} ];
    UITabBarController *tab = [[UITabBarController alloc]init];
    tab.tabBar.barTintColor = [UIColor whiteColor];
    //tab.tabBar.tintColor = [UIColor colorWithRed:0.92 green:0.50 blue:0.06 alpha:1.00];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = nil;
        RTRootNavigationController *nav = nil;
        if (idx == 0) {
            vc = [HomeVC shareInstance];
            nav = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        }else {
            vc = [NSClassFromString(dict[ClassKey]) new];
        }
        nav = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        vc.title = dict[TitleKey];
        vc.navigationController.navigationBar.barTintColor = [Color colorWithHex:@"#3B3B3B"];
        [vc.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:BoldFont(18),NSForegroundColorAttributeName:[UIColor whiteColor]}];
        vc.navigationController.navigationBar.translucent = YES;
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[TitleKey];
        item.image = [[UIImage imageNamed:dict[ImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:dict[SelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tab addChildViewController:nav];
    }];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [Color colorWithHex:@"#515151"],NSFontAttributeName:LightFont(12)} forState:UIControlStateNormal];
    return tab;
}

+ (BOOL)judgeRequestAvailable:(id)response
{
    if ([response[@"status"][@"succeed"] integerValue] == 1) {
        return YES;
    }else {
        if ([response[@"status"][@"error_code"] integerValue] == 100) {
            if (![YPC_Tools shareInstance].alertView) {
                [YPC_Tools shareInstance].alertView = [[LGAlertView alloc] initWithTitle:@"提示"
                                                                                 message:@"该账号已经过期, 请重新登录"
                                                                                   style:LGAlertViewStyleAlert
                                                                            buttonTitles:nil
                                                                       cancelButtonTitle:nil
                                                                  destructiveButtonTitle:@"确定"
                                                                           actionHandler:nil
                                                                           cancelHandler:nil
                                                                      destructiveHandler:^(LGAlertView *alertView) {
//                                                                          [NotificationCenter postNotificationName:DidReceiveAccountDidOutOfDate object:nil];
                                                                      }];
                [[YPC_Tools shareInstance].alertView showAnimated:YES completionHandler:nil];
                return NO;
            }
            return NO;
        }
        [YPC_Tools showSvpWithNoneImgHud:response[@"status"][@"error_desc"]];
        return NO;
    }
}

+ (BOOL)judgeFooterDataAvailable:(id)response
{
    if ([response[@"paginated"][@"more"] isEqual:@1]) {
        return YES;
    }else if([response[@"paginated"][@"more"] isEqual:@0]) {
        return NO;
    }
    return NO;
}

+ (void)judgeFooterIsHidden:(id)response WithTV:(UITableView *)tableView
{
    if ([response[@"data"] count] == 0) {
        tableView.mj_footer.hidden = YES;
    }else if([response[@"data"] count] > 0) {
        tableView.mj_footer.hidden = NO;
    }
}

+ (CGFloat)heightForText:(NSString *)text Font:(UIFont *)font Width:(CGFloat)width
{
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height + 4;
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (NSAttributedString *)addLineForString:(NSString *)str
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    return attribtStr;
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString Format:(NSString *)format
{
    NSTimeInterval time=[timeString doubleValue]; //因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

+ (BOOL)intervalFromLastDate:(NSString *)dateString
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [date stringFromDate:[NSDate date]];
    
    NSDate *d1            = [date dateFromString:dateTime];
    NSTimeInterval late1  = [d1 timeIntervalSince1970]*1;
    
    NSDate *d2            = [date dateFromString:dateString];
    NSTimeInterval late2  = [d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha    = late2 - late1;
    NSString *timeString  = @"";
    NSString *house       = @"";
    NSString *min         = @"";
    NSString *sen         = @"";
    
    // 秒
    sen        = [NSString stringWithFormat:@"%d", (int)cha%60];
    sen        = [NSString stringWithFormat:@"%@", sen];
    
    // 分
    min        = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    min        = [NSString stringWithFormat:@"%@", min];
    
    // 小时
    house      = [NSString stringWithFormat:@"%d", (int)cha/3600];
    house      = [NSString stringWithFormat:@"%@", house];
    
    timeString = [NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    int end_hour   = [[timeString componentsSeparatedByString:@":"][0] intValue];
    int end_min    = [[timeString componentsSeparatedByString:@":"][1] intValue];
    int end_second = [[timeString componentsSeparatedByString:@":"][2] intValue];
    
    long totalTimes = end_hour*60*60 + end_min*60 + end_second;
    
    if (totalTimes < 0) {
        return YES;
    }else {
        return NO;
    }
}

+ (UrlSechmeType)judgementUrlSechmeTypeWithUrlString:(NSString *)urlString
{
    if ([urlString hasPrefix:@"http://"]) {
        return urlSechmeWebView;
    }else if ([urlString hasPrefix:@"ypcang://"]) {
        NSRange range = [urlString rangeOfString:@"ypcang://"];
        NSString *subStr = [urlString substringFromIndex:range.length];
        if ([subStr hasPrefix:@"goods"]) {
            return urlSechmeGoodsDetail;
        }else if ([subStr hasPrefix:@"activity"]) {
            return urlSechmeActivityDeatail;
        }else if ([subStr hasPrefix:@"seller"]) {
            return urlSechmeLivingGroupDetail;
        }else if ([subStr hasPrefix:@"brand"]) {
            return urlSechmeBrandDetail;
        }else {
            return urlSechmeNone;
        }
    }else {
        return urlSechmeNone;
    }
}

+ (void)openConversationWithCilentId:(NSString *)clientId andViewController:(UIViewController *)vc
{
    [YPCNetworking postWithUrl:@"merchant/user/infobylean"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"client": clientId}]
                       success:^(id response) {
                           NSNumber *num = [NSNumber numberWithInteger:0];
                           if (response[@"status"][@"succeed"] != num) {
                               
                               LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:clientId];;
                               conversationViewController.enableAutoJoin = YES;
                               conversationViewController.disableTitleAutoConfig = YES;
                               [vc.navigationController pushViewController:conversationViewController animated:YES];
                               
                               [conversationViewController setViewDidLoadBlock:^(__kindof LCCKBaseViewController *viewController) {
                                   
                                   viewController.navigationController.navigationBar.barTintColor = [Color colorWithHex:@"#3B3B3B"];
                                   viewController.navigationController.navigationBar.translucent = YES;
                                   [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:BoldFont(18),NSForegroundColorAttributeName:[UIColor whiteColor]}];
                                   viewController.title = [[(NSDictionary *)response[@"data"] objectForKey:@"member_truename"] class] == [NSNull class] ? @"私信" : response[@"data"][@"member_truename"];

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
}
+ (void)naviRightAction:(UIButton *)sender
{
    UIViewController *VC = objc_getAssociatedObject(sender, @"backObject");
    [VC.navigationController popViewControllerAnimated:YES];
}

+ (UIViewController *)getControllerWithView:(id)view
{
    id object = [view nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    return (UIViewController*)object;
}

@end
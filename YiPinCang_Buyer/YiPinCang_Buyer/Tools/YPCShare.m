//
//  YPCShare.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "YPCShare.h"

@implementation YPCShare

+ (void)StoreShareInWindowWithStoreName:(NSString *)shareStoreName
                                StoreId:(NSString *)shareStoreId
                                  image:(id)shareImg
                                    uid:(NSString *)uid
                         viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeStore
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_store.title, shareStoreName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_store.content, shareStoreName]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_store.url, shareStoreId,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)GoodsShareInWindowWithStraceName:(NSString *)shareStraceName
                                StraceId:(NSString *)shareStraceId
                                   image:(id)shareImg
                                discount:(NSString *)discount
                                   price:(NSString *)price
                                     uid:(NSString *)uid
                          viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeGoods
                                               Title:[YPCRequestCenter shareInstance].configModel.share_goods.title
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_goods.content,shareStraceName,discount,price]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_goods.url, shareStraceId,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)StartActivityShareInWindowWithName:(NSString *)shareName
                                 StartTime:(NSString *)shareStartTime
                                    LiveID:(NSString *)shareLiveId
                                     image:(id)shareImg
                                 brandName:(NSString *)brandName
                                   endTime:(NSString *)endTime
                                       uid:(NSString *)uid
                            viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeStartActivity
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_live_activity.title, shareName,brandName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_live_activity.content, shareName, brandName,endTime]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_live_activity.url, shareLiveId,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)WillActivityShareInWindowWithName:(NSString *)shareName
                                StartTime:(NSString *)shareStartTime
                                   LiveID:(NSString *)shareLiveId
                                    image:(id)shareImg
                                brandName:(NSString *)brandName
                                  endTime:(NSString *)endTime
                                      uid:(NSString *)uid
                           viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeWillActivity
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_will_activity.title, shareName,brandName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_will_activity.content, shareName, brandName,endTime]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_will_activity.url, shareLiveId,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)EndActivityShareInWindowWithName:(NSString *)shareName
                               StartTime:(NSString *)shareStartTime
                                  LiveID:(NSString *)shareLiveId
                                   image:(id)shareImg
                            activityName:(NSString *)activityName
                                     uid:(NSString *)uid
                          viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeEndActivity
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_end_activity.title, shareName,activityName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_end_activity.content, shareName, activityName,shareStartTime]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_end_activity.url, shareLiveId,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)BrandShareInWindowWithBrandName:(NSString *)shareBrandName
                       BrandDescription:(NSString *)shareBrandDescription
                                BrandID:(NSString *)brandID
                                  image:(id)shareImg
                                    uid:(NSString *)uid
                         viewController:(UIViewController *)VC
{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeBrand
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.title, shareBrandName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.content, shareBrandName, shareBrandDescription]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.url, brandID,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)BrandActivityShareInWindowWithBrandName:(NSString *)shareBrandName
                               BrandDescription:(NSString *)shareBrandDescription
                                        BrandID:(NSString *)brandID
                                          image:(id)shareImg
                                            uid:(NSString *)uid
                                 viewController:(UIViewController *)VC{
    if ([YPCRequestCenter shareInstance].configModel) {
        
        [self showShareMenuViewInWindowWithShareType:ShareStateTypeBrandActivity
                                               Title:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.title, shareBrandName]
                                             Content:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.content, shareBrandName, shareBrandDescription]
                                                 url:[NSString stringWithFormat:[YPCRequestCenter shareInstance].configModel.share_brand.url, brandID,uid]
                                               image:shareImg
                                      viewController:VC];
    }else {
        [YPC_Tools showSvpHudError:@"无法分享"];
    }
}

+ (void)showShareMenuViewInWindowWithShareType:(ShareStateType)shareType
                                         Title:(NSString *)shareTitle
                                       Content:(NSString *)shareContent
                                           url:(NSString *)shareUrl
                                         image:(id)shareImg
                                viewController:(UIViewController *)VC
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *object = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareContent thumImage:shareImg];
        shareObject.webpageUrl = shareUrl;
        object.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:object
                                    currentViewController:VC completion:^(id result, NSError *error) {
                                        YPCAppLog(@"%@", result);
                                        if (!error) {
                                            [YPC_Tools showSvpWithNoneImgHud:@"分享成功"];
                                        }
                                    }];
    }];
}

@end

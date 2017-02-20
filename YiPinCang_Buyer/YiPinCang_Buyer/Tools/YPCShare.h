//
//  YPCShare.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPCShare : NSObject

/*!
 *
 *    分享直播组
 *
 */
+ (void)StoreShareInWindowWithStoreName:(NSString *)shareStoreName
                                StoreId:(NSString *)shareStoreId
                                  image:(id)shareImg
                                    uid:(NSString *)uid
                         viewController:(UIViewController *)VC;

/*!
 *
 *    分享商品贴
 *
 */
+ (void)GoodsShareInWindowWithStraceName:(NSString *)shareStraceName
                                StraceId:(NSString *)shareStraceId
                                   image:(id)shareImg
                                discount:(NSString *)discount
                                   price:(NSString *)price
                                     uid:(NSString *)uid
                          viewController:(UIViewController *)VC;

/*!
 *
 *    分享正在直播活动
 *
 */
+ (void)StartActivityShareInWindowWithName:(NSString *)shareName
                                 StartTime:(NSString *)shareStartTime
                                    LiveID:(NSString *)shareLiveId
                                     image:(id)shareImg
                                 brandName:(NSString *)brandName
                                   endTime:(NSString *)endTime
                                       uid:(NSString *)uid
                            viewController:(UIViewController *)VC;

/*!
 *
 *    分享预热活动
 *
 */
+ (void)WillActivityShareInWindowWithName:(NSString *)shareName
                                StartTime:(NSString *)shareStartTime
                                   LiveID:(NSString *)shareLiveId
                                    image:(id)shareImg
                                brandName:(NSString *)brandName
                                  endTime:(NSString *)endTime
                                      uid:(NSString *)uid
                           viewController:(UIViewController *)VC;

/*!
 *
 *    分享已结束活动
 *
 */
+ (void)EndActivityShareInWindowWithName:(NSString *)shareName
                               StartTime:(NSString *)shareStartTime
                                  LiveID:(NSString *)shareLiveId
                                   image:(id)shareImg
                            activityName:(NSString *)activityName
                                     uid:(NSString *)uid
                          viewController:(UIViewController *)VC;

/*!
 *
 *    分享品牌
 *
 */
+ (void)BrandShareInWindowWithBrandName:(NSString *)shareBrandName
                       BrandDescription:(NSString *)shareBrandDescription
                                BrandID:(NSString *)brandID
                                  image:(id)shareImg
                                    uid:(NSString *)uid
                         viewController:(UIViewController *)VC;
/*!
 *
 *   品牌活动分享
 *
 */
+ (void)BrandActivityShareInWindowWithBrandName:(NSString *)shareBrandName
                       BrandDescription:(NSString *)shareBrandDescription
                                BrandID:(NSString *)brandID
                                  image:(id)shareImg
                                    uid:(NSString *)uid
                         viewController:(UIViewController *)VC;

@end

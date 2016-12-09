//
//  YPCShareInformation.h
//  TaoFactory_Seller
//
//  Created by YPC on 16/10/13.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface YPCShareInformation : NSObject

// 分享到微信朋友圈
/*
 @param shareTitle         分享的标题
 @param shareContent       分享的文字内容
 @param shareURL           分享的链接
 @param shareImage         分享的图片(UIImage *)
 @param viewController     如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */


// 分享到微信好友
/*
 @param shareTitle         分享的标题
 @param shareContent       分享的文字内容
 @param shareURL           分享的链接
 @param shareImage         分享的图片(UIImage *)
 @param viewController     如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */


// 分享到手机QQ
/*
 @param shareTitle         分享的标题
 @param shareContent       分享的文字内容
 @param shareURL           分享的链接
 @param shareImage         分享的图片(ImageURL)
 @param viewController     如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */

// 分享到新浪微博
/*
 @param shareTitle         分享的标题
 @param shareContent       分享的文字内容
 @param shareURL           分享的链接
 @param shareImage         分享的图片(ImageURL)
 @param viewController     如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */


@end

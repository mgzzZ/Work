//
//  PayManager.h
//  FrameWork2.0
//
//  Created by ricky on 16/9/12.
//  Copyright © 2016年 yanjiaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "WXApi.h"
typedef void(^successBlock)();
typedef void(^failureBlock)(NSString *error);

@interface PayManager : NSObject
+ (void)doAlipayPay:(NSString *)orderName orderNumebr:(NSString *)orderNumebr orderPrice:(NSString *)orderPrice success:(successBlock )success failur:(failureBlock )failur;
+ (void)doWechatPay:(NSString *)orderName orderNumebr:(NSString *)orderNumebr orderPrice:(NSInteger)orderPrice success:(successBlock )success failur:(failureBlock )failur;

+ (void)doAlipayPayNoPrivateKey:(NSString *)orderPrice service:(NSString *)service notify_url:(NSString *)notify_url out_trade_no :(NSString *)out_trade_no subject:(NSString *)subject body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur;
+ (void)doAlipayPayNoNONO:(NSString *)orderPrice body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur;

+ (void)doWechatPayNoNONO:(NSString *)prepay_id body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur;


@end

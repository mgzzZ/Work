//
//  PayManager.m
//  FrameWork2.0
//
//  Created by ricky on 16/9/12.
//  Copyright © 2016年 yanjiaming. All rights reserved.
//

#import "PayManager.h"
#import "XMLDictionary.h"

#define SP_URL [NSString stringWithFormat:@"http://yueban.demo.sainti.net/app_api/index.php/"]
@implementation PayManager



+ (void)doAlipayPay:(NSString *)orderName orderNumebr:(NSString *)orderNumebr orderPrice:(NSString *)orderPrice success:(successBlock )success failur:(failureBlock )failur{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2088121008244602";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALcgkBTNReAJyTaRiEf2TMwV3miC5VD3BMkk3FHcNoXD7VYva4SwnQ1cNK7+LeuWAmVLMBzJ0ZWAJKrGgcS09GRm4DT8eTO7GqPZHFmsYjBaEHJqbNqORPMpYfOBoNpVeD5kyGgCDfXavXg3Q6EObf7uVcOKnJsV3bW0hEWkN0ezAgMBAAECgYB1AQAt2k3n7Di8fdW2LN86kkptOhzsUzeikMOYJfxMETgGFfw7ZmCiFaSvnkWWvVzAfX67FhOr0pka6AQnu3pdyzaFKmEITHphU45aiV98cJ08ONuy+BuiDgYp61rfHffnkJhsYWkdzrR4D9F1FWmLAb8wEOIkOx6cO/CALitPWQJBAN62n77ZTcwCR+nWxa29xJ7yX8/aeJNaf9XB7tvPmfMKMWKneWmF5C4oFk+BAUz/zGptoukngim+z7v/Bh+0OJcCQQDSf06rrTKPbfb19L97uQsm3JPMZ78l+7ul49gbJzz3yC0T7o+ptUKm/N7ylBABHpHSAiYMCWWz+STXSbSwbhFFAkAta+WMkNkTAGwWPt02H/vXxurPg2kP9GcZ+2Fxpxdov+1uh2V1pf7xgu9563+OaqUQF6ggERS02tuXJd3j3WelAkEAxhfOhltxCG+5CJAyn5FtwD22zZcY2PsFBcHc/vi3NIvqeCZ6hoAxYIr6mRjj0tnc6uDgw1UYo/0kQYJ4i8yZbQJAAyvzK5irpyeL0+tkyWU4nF/ddKqv+kyLfsEwh8wrIB6Av8PK7mhVvVwm5MP0shtQu+kUtbSn3xAwiVD72MnEgQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称 //service
    order.method = @"alipay.trade.app.pay";//
    //notify_url
    order.notify_url = [NSString stringWithFormat:@"%@%@",@"",@"alipay_notify_url" ];
    order.return_url = [NSString stringWithFormat:@"%@%@",@"",@"alipay_notify_url" ];
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = orderName;//body
    order.biz_content.subject = orderName;//subject
    order.biz_content.out_trade_no = orderNumebr; //订单ID（由商家自行制定）out_trade_no
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = orderPrice; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
   // NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"YPCBuyer";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"result"] isEqualToString:@""]) {
                if (failur) {
                    NSString * error = resultDic[@"memo"];
                    failur(error);
                }
            }else{
                if (success) {
                    success();
                }
            }
        }];
    }

}

+ (void)doWechatPay:(NSString *)orderName orderNumebr:(NSString *)orderNumebr orderPrice:(NSInteger)orderPrice success:(successBlock )success failur:(failureBlock )failur{
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    
    NSString    *time_stamp;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@wx_order_create?device_info=ios&out_trade_no=%@&body=%@&total_fee=%zd&timestamp=%@",
                           @"http://139.224.46.57/ypcang-api/api/ecapi/payment/wxpay/",
                           orderNumebr,
                           orderNumebr,
                           orderPrice,time_stamp];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //[self showProgressWithView:self.view animated:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void){
        
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //[self hideProgress:self.view animated:YES];
            if ( response != nil) {
                //解析服务端返回json数据
                NSError *error;
                //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
                NSMutableDictionary *resParams = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                if ([[resParams objectForKey:@"result"] isEqual:@"1"]) {
                    NSDictionary *dataDic = [resParams objectForKey:@"data"];
                    NSMutableString *stamp  = [dataDic objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = [dataDic objectForKey:@"appid"];
                    req.partnerId           = [dataDic objectForKey:@"partnerid"];
                    req.prepayId            = [dataDic objectForKey:@"prepayid"];
                    req.nonceStr            = [dataDic objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.integerValue;
                    req.package             = [dataDic objectForKey:@"package"];
                    req.sign                = [dataDic objectForKey:@"sign"];
                    
                    BOOL resutlts = [WXApi sendReq:req];
                    if (resutlts) {
                        
                        if (success) {
                            success();
                        }
                    
                    }else{
                        
                    }
                }else{
                    if (failur) {
                        failur([resParams objectForKey:@"msg"]);
                    }
                    
                }
                
                
            }
            
        });
    });

}
+ (void)doAlipayPayNoPrivateKey:(NSString *)orderPrice service:(NSString *)service notify_url:(NSString *)notify_url out_trade_no :(NSString *)out_trade_no subject:(NSString *)subject body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2088121008244602";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPQjNlI3ohuNYuNPuFrZqNUyp/L+mTkPOpLv2at8zeYk/6wKHkhoAV+/RNLbtsRs/HCcuH1c8nMiFcvcMAx461RS1h7YhGmbcTLvFeQ704bsw5XA4K4EAVIusT2V9UmtFV7oh6VutMy0T5oH2v/0STijQylgvSEWKcvieYiRmMdnAgMBAAECgYAJ65BegOI2amVVRT0BfAyvNRK7/fpt5h+ELvjSTgzzyBcXf4XBfXBo2pXKV6EylBch4Exi068KXJ00HmtZZmRxgWYsjS3Z3VSalHzvcVKJF9ROLj5TObY1P172GBcX8ymIdaMF/1jTInZsAz+k1VS0jDQHmzeZgFvm7/VifTVtyQJBAP6fz8VwOC1pxHbYjOj2ZSsfs9bW9xPMdQ0ssZEDl1yAfNFO51FHF5R4rtllv4cdhwytrMynP2o8kZs75cgs5R0CQQD1dOVLkN9QwoNq7IAns9npHLg8eIKK8Al9A/k4c/Oo+gzzB47g4eKRONTpFWZmrZR4DfVkk42n8ktOnKrmp0tTAkEAi26YKFY7bSLuIuaSwz+qRuMlaBBvXLgpoP1If1CoIk96CmRa53c2wmcT2JiPOT5CJf81ERzE7TgdxBQY0HVFQQJBAMMOUejrB4u2B5lAt9bVJaYKHJ5xZcvjVKb0MWibPFZb306CAxjSaKne79MKHoYaCpIdBZUXbMq50P53oZgJ+eECQB3YY+Nv+1MpgB9OX8VHjLYQ5ZlNalCU+0lkj2/VjmYuI1Q2q8ed5ozQWITmqc8n+hXrmVaEPOYKi108U5t8D2c=";
    //
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称 //service
    order.method = service;//
    //notify_url
    order.notify_url = notify_url;
    order.return_url = notify_url;
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = body;//body
    order.biz_content.subject = subject;//subject
    order.biz_content.out_trade_no = out_trade_no; //订单ID（由商家自行制定）out_trade_no
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = orderPrice; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    // NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"YPCBuyer";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"result"] isEqualToString:@""]) {
                if (failur) {
                    NSString * error = resultDic[@"memo"];
                    failur(error);
                }
            }else{
                if (success) {
                    success();
                }
            }
        }];
    }

}

+ (void)doAlipayPayNoNONO:(NSString *)orderPrice body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"YPCBuyer";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:body fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"result"] isEqualToString:@""]) {
            if (failur) {
                NSString * error = resultDic[@"memo"];
                failur(error);
            }
        }else{
            if (success) {
                success();
            }
        }
    }];
};

+ (void)doWechatPayNoNONO:(NSString *)prepay_id body:(NSString *)body success:(successBlock )success failur:(failureBlock )failur{
    
    //解析服务端返回json数据
    //                NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    
    NSDictionary *resParams = [NSDictionary dictionaryWithXMLString:body];
    
    NSString *timeSp = [resParams objectForKey:@"timeStamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [resParams objectForKey:@"openID"];
    req.partnerId           = [resParams objectForKey:@"partnerId"];
    req.prepayId            = [resParams objectForKey:@"prepayId"];
    req.nonceStr            = [resParams objectForKey:@"nonceStr"];
    req.timeStamp           = timeSp.integerValue;
    req.package             = [resParams objectForKey:@"package"];
    req.sign                = [resParams objectForKey:@"sign"];
    
    BOOL resutlts = [WXApi sendReq:req];
    if (resutlts) {
        
        if (success) {
            success();
        }
        
    }else{
        if (failur) {
            failur([resParams objectForKey:@"msg"]);
        }
    }
    
    
    
    
}
@end

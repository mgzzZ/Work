//
//  GoodsMessage.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/7.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "GoodsMessage.h"

@implementation GoodsMessage

/*!
 * 有几个必须添加的字段：
 *  - degrade 用来定义如何展示老版本未支持的自定义消息类型
 *  - typeTitle 最近对话列表中最近一条消息的title，比如：最近一条消息是图片，可设置该字段内容为：`@"图片"`，相应会展示：`[图片]`。
 *  - summary 会显示在 push 提示中
 * @attention 务必添加这三个字段，ChatKit 内部会使用到。
 */
- (instancetype)initWithOrderModel:(OrderDetailModel *)orderModel conversationType:(LCCKConversationType)conversationType
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self lcck_setObject:@"商品订单" forKey:LCCKCustomMessageTypeTitleKey];
    [self lcck_setObject:@"这是一条商品订单消息，当前版本过低无法显示，请尝试升级APP查看" forKey:LCCKCustomMessageDegradeKey];
    [self lcck_setObject:@"有人向您发送了商品订单消息，请打开APP查看" forKey:LCCKCustomMessageSummaryKey];
    [self lcck_setObject:@(conversationType) forKey:LCCKCustomMessageConversationTypeKey];
    [self lcck_setObject:orderModel.order_id forKey:@"orderID"];
    return self;
}

+ (instancetype)GoodsMessageWithOrderModel:(OrderDetailModel *)orderModel conversationType:(LCCKConversationType)conversationType
{
    return [[self alloc] initWithOrderModel:orderModel conversationType:conversationType];
}

+ (void)load {
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageGoods;
}


@end

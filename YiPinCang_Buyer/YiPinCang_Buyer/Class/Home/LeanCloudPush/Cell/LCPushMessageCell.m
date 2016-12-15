//
//  OrderMessageCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LCPushMessageCell.h"
@interface LCPushMessageCell ()
@property (nonatomic, strong) IBOutlet UILabel *timeL;
@property (nonatomic, strong) IBOutlet UILabel *titleL;
@property (nonatomic, strong) IBOutlet UILabel *LogisticsL;
@property (nonatomic, strong) IBOutlet UILabel *desL;
@property (nonatomic, strong) IBOutlet UIImageView *orderImgV;
@property (nonatomic, strong) IBOutlet UILabel *LogisticsNum;
@end

@implementation LCPushMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSystemModel:(SystemMessageModel *)systemModel
{
    _systemModel = systemModel;
    self.timeL.text = [YPC_Tools timeWithTimeIntervalString:_systemModel.add_time Format:@"YYYY年MM月dd日 HH:mm"];
    self.titleL.text = _systemModel.t_title;
    self.desL.text = _systemModel.t_msg;
}

- (void)setOrderModel:(OrderMessageModel *)orderModel
{
    _orderModel = orderModel;
    self.timeL.text = [YPC_Tools timeWithTimeIntervalString:_systemModel.add_time Format:@"YYYY年MM月dd日 HH:mm"];
//    if (_orderModel.order_state.integerValue == 0) {
//        self.titleL.text = @"订单已取消";
//    }else if (_orderModel.order_state.integerValue == 10) {
//        self.titleL.text = @"订单已生成";
//    }else if (_orderModel.order_state.integerValue == 20) {
//        self.titleL.text = @"订单已付款";
//    }else if (_orderModel.order_state.integerValue == 30) {
//        self.titleL.text = @"订单已发货";
//    }else if (_orderModel.order_state.integerValue == 40) {
//        self.titleL.text = @"订单已完成";
//    }
    if (_orderModel.order_state.integerValue == 40) {
        self.titleL.textColor = [Color colorWithHex:@"#36A74D"];
    }else {
        self.titleL.textColor = [Color colorWithHex:@"#E4393C"];
    }
    self.titleL.text = _orderModel.t_msg;
    self.LogisticsL.text = [NSString stringWithFormat:@"(%@)", _orderModel.t_title];
    self.desL.text = _orderModel.goods_name;
    [self.orderImgV sd_setImageWithURL:[NSURL URLWithString:_orderModel.goods_image] placeholderImage:YPCImagePlaceHolderSquare];
    self.LogisticsNum.text = [NSString stringWithFormat:@"订单编号:%@", _orderModel.shipping_code];
}

- (void)setActivityModel:(ActivityMessageModel *)activityModel
{
    _activityModel = activityModel;
    self.timeL.text = [YPC_Tools timeWithTimeIntervalString:_activityModel.add_time Format:@"YYYY年MM月dd日 HH:mm"];
    self.titleL.text = _activityModel.t_title;
    self.desL.text = _activityModel.t_msg;
}


@end

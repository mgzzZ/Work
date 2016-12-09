//
//  ShoppongCarCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ShoppongCarCell.h"

@implementation ShoppongCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setModel:(Shoppingcar_dataModel *)model{
    WS(weakself);
    if (_model != model) {
        _model = model;
    }
    
    if ([model.type isEqualToString:@"1"]) {
        self.payCount1.hidden = NO;
        self.payCount2.hidden = NO;
        self.choose2Btn.userInteractionEnabled = YES;
        self.Choose1Btn.userInteractionEnabled = YES;
        self.choose2Btn.selected = model.seleted;
        self.Choose1Btn.selected = model.seleted;
        self.payCount1.currentNumber = model.goods_num;
        self.payCount2.currentNumber = model.goods_num;
        
        self.payCount1.maxValue = model.goods_storage.integerValue;
        self.payCount2.maxValue = model.goods_storage.integerValue;
        
        self.payCount1.numberBlock = ^(NSString *num){
            weakself.countLab.text = [NSString stringWithFormat:@"×%@",num];
            if (weakself.payCountBlock) {
                weakself.payCountBlock(num);
            }
        };
        self.payCount2.numberBlock = ^(NSString *num){
            weakself.countLab.text = [NSString stringWithFormat:@"×%@",num];
            if (weakself.payCountBlock) {
                weakself.payCountBlock(num);
            }
        };
        self.typeLab.layer.cornerRadius = 0;
        self.typeLab.layer.borderWidth = 0;
        self.typeLab.layer.borderColor = [UIColor whiteColor].CGColor;
        if (!_timer) {
            __block int timeout = model.remaintime.intValue; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.typeLab.text = @"过期失效";
                        weakself.payCount1.hidden = YES;
                        weakself.payCount2.hidden = YES;
                        weakself.typeLab.textColor = [UIColor grayColor];
                    });
                }else{
                    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",minutes, seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.typeLab.text = strTime;
                        
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
        }
        

    }else{
        self.choose2Btn.userInteractionEnabled = NO;
        self.Choose1Btn.userInteractionEnabled = NO;
        self.payCount1.hidden = YES;
        self.payCount2.hidden = YES;
        if ([model.type isEqualToString:@"2"]) {
            self.typeLab.text = @"下架";
        }else if ([model.type isEqualToString:@"3"]){
            self.typeLab.text = @"库存不足";
        }else if ([model.type isEqualToString:@"4"]){
            self.typeLab.text = @"售罄";
        }else{
            self.typeLab.text = @"过期失效";
        }

        self.typeLab.textColor = [UIColor grayColor];
    }
    self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.nameLab.text = model.goods_name;
    self.price1Lab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.price2Lab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    [self.storeImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
    [self.strre2Img sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.countLab.text = [NSString stringWithFormat:@"×%@",model.goods_num];
    self.sizeLab.text = model.goods_spec;
    self.sizeLab2.text = model.goods_spec;
    
}


//删除
- (IBAction)deleteClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
//状态1 选择
- (IBAction)choose1BtnClick:(UIButton *)sender {
    
    if (self.seleteBlock) {
        self.seleteBlock(sender);
    }
    sender.selected =! sender.selected;
    self.choose2Btn.selected = sender.selected;
}
//状态2 选择
- (IBAction)choose2BtnClick:(UIButton *)sender {
    if (self.seleteBlock) {
        self.seleteBlock(sender);
    }
    sender.selected =! sender.selected;
    self.Choose1Btn.selected = sender.selected;
}
//选择尺码
- (IBAction)chooseSizeBtnClick:(UIButton *)sender {
    if (self.chooseBlock) {
        self.chooseBlock();
    }
}

@end

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
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) {
        self.payCount1.hidden = NO;
        self.payCount2.hidden = NO;
        self.payBtn.hidden = YES;
        self.choose2Btn.userInteractionEnabled = YES;
        self.Choose1Btn.userInteractionEnabled = YES;
        self.choose2Btn.selected = model.seleted;
        self.Choose1Btn.selected = model.seleted;
        
        
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
        self.payCount1.maxValue = model.goods_storage.integerValue;
        self.payCount2.maxValue = model.goods_storage.integerValue;
        self.payCount1.currentNumber = model.goods_num;
        self.payCount2.currentNumber = model.goods_num;
        if ([model.type isEqualToString:@"2"]) {
            self.countView1.hidden = NO;
            self.countView2.hidden = NO;
            self.scountLab1.text = [NSString stringWithFormat:@"仅剩%@件",model.goods_storage];
            self.scountLab2.text = [NSString stringWithFormat:@"仅剩%@件",model.goods_storage];
//            NSInteger  count = model.goods_num.integerValue > model.goods_storage.integerValue ? model.goods_storage.integerValue : model.goods_num.integerValue;
//            self.payCount1.currentNumber = [NSString stringWithFormat:@"%zd",count];
//            self.payCount2.currentNumber = [NSString stringWithFormat:@"%zd",count];
            
            
        }else{
            self.countView1.hidden = YES;
            self.countView2.hidden = YES;
            self.scountLab2.hidden = YES;
            self.scountLab1.hidden = YES;
            
           
        }
        self.typeLab.hidden = YES;
    }else{
        self.countView1.hidden = YES;
        self.countView2.hidden = YES;
        self.scountLab2.hidden = YES;
        self.scountLab1.hidden = YES;
        self.choose2Btn.userInteractionEnabled = NO;
        self.Choose1Btn.userInteractionEnabled = NO;
        self.payCount1.hidden = YES;
        self.payCount2.hidden = YES;
        
        
       if ([model.type isEqualToString:@"3"]){
            [self.choose2Btn setImage:IMAGE(@"cart_xiajia_icon") forState:UIControlStateNormal];
            [self.Choose1Btn setImage:IMAGE(@"cart_xiajia_icon") forState:UIControlStateNormal];
            self.typeLab.text = @"下架";
            self.payBtn.hidden = YES;
        }else if ([model.type isEqualToString:@"4"]){
            self.payBtn.hidden = YES;
            self.price1Lab.textColor = [Color colorWithHex:@"0x999999"];
            self.typeLab.text = @"售罄";
            [self.choose2Btn setImage:IMAGE(@"cart_soldout_icon") forState:UIControlStateNormal];
            [self.Choose1Btn setImage:IMAGE(@"cart_soldout_icon") forState:UIControlStateNormal];
            
        }else{
            self.payBtn.hidden = NO;
            self.typeLab.text = @"过期失效";
            [self.choose2Btn setImage:IMAGE(@"cart_guoqi_icon") forState:UIControlStateNormal];
            [self.Choose1Btn setImage:IMAGE(@"cart_guoqi_icon") forState:UIControlStateNormal];
            
            [self.payBtn setTitleColor:[Color colorWithHex:@"#F00E36"] forState:UIControlStateNormal];
            self.payBtn.layer.borderColor = [Color colorWithHex:@"#F00E36"].CGColor;
            self.payBtn.layer.borderWidth = 1;
        }
        //self.typeLab.hidden = NO;
        self.typeLab.textColor = [UIColor grayColor];
    }
    self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.nameLab.text = model.goods_name;
    self.price1Lab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.price2Lab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    [self.storeImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image_thumb] placeholderImage:YPCImagePlaceHolder];
    [self.strre2Img sd_setImageWithURL:[NSURL URLWithString:model.goods_image_thumb] placeholderImage:YPCImagePlaceHolder];
    self.countLab.text = [NSString stringWithFormat:@"×%@",model.goods_num];
    self.sizeLab.text = model.goods_spec;
    NSString *goods_spec = [model.goods_spec stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    if (goods_spec.length == 0) {
        self.sizeLab2.text = @"暂无尺码";
    }else{
        self.sizeLab2.text = goods_spec;
    }
    if ([self.type isEqualToString:@"0"]) {
        self.originalPriceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_marketprice];
        [self.originalPriceLab sizeToFit];
        self.originalPriceLab.sd_layout.widthIs(self.originalPriceLab.frame.size.width);
    }
}


//删除
- (IBAction)deleteClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
//状态1 选择
- (IBAction)choose1BtnClick:(UIButton *)sender {
    if ([self.model.type isEqualToString:@"2"] && sender.selected == NO) {
       [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"您添加的商品购买数量大于库存数量,请更改购买数量" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
           if (self.seleteBlock) {
               self.seleteBlock(sender);
           }
           sender.selected =! sender.selected;
           self.choose2Btn.selected = sender.selected;
       } cancelHandler:nil destructiveHandler:nil];
    }else{
        if (self.seleteBlock) {
            self.seleteBlock(sender);
        }
        sender.selected =! sender.selected;
        self.choose2Btn.selected = sender.selected;
    }
    
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

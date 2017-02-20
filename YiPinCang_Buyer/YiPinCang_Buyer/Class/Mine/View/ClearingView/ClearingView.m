//
//  ClearingView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/21.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ClearingView.h"

@implementation ClearingView




- (instancetype)init{
    self = [super init];
    if (self) {
     
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        [self setup];
    }
    return self;
}
- (void)setup{
    self.clearingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearingBtn.backgroundColor = [Color colorWithHex:@"#F00E36"];
    [self.clearingBtn setTitle:@"结算" forState:UIControlStateNormal];
    [self.clearingBtn addTarget:self action:@selector(clearingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.clearingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clearingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.clearingBtn];
    self.clearingBtn.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(kWidth(100));
    self.seleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.seleteBtn setImage:[UIImage imageNamed:@"mmine_cart_button_unclicked"] forState:UIControlStateNormal];
    [self.seleteBtn setImage:[UIImage imageNamed:@"mmine_cart_button_clicked"] forState:UIControlStateSelected];
    [self.seleteBtn addTarget:self action:@selector(seleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.seleteBtn.selected = NO;
    [self addSubview:self.seleteBtn];
    self.seleteBtn.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(40);
    self.seleteLab = [[UILabel alloc]init];
    self.seleteLab.text = @"全选";
    self.seleteLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.seleteLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.seleteLab];
    self.seleteLab.sd_layout
    .leftSpaceToView(self.seleteBtn,0)
    .centerYEqualToView(self)
    .heightIs(20)
    .widthIs(70);
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textAlignment = NSTextAlignmentRight;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.priceLab];
    self.priceLab.sd_layout
    .leftSpaceToView(self.seleteLab,0)
    .rightSpaceToView(self.clearingBtn,5)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    NSString *str = @"合计: ¥0";
    NSMutableAttributedString * mutabStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mutabStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(0, 3)];
    [mutabStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#E4393C"] range:NSMakeRange(3, str.length - 3)];
    self.priceLab.attributedText = mutabStr;
    
}
- (void)clearingBtnClick{
    if (self.cliearingBtnBlock) {
        self.cliearingBtnBlock();
    }
}
- (void)seleteBtnClick:(UIButton *)sender{
    if (self.seleteBtnBlock) {
        self.seleteBtnBlock(sender);
    }
    sender.selected =! sender.selected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

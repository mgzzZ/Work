//
//  AreaCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AreaCell.h"

@implementation AreaCell



- (void)setModel:(AreaListModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.nameLab.text = [NSString stringWithFormat:@"%@  %@",model.true_name,model.mob_phone];
    if ([model.is_default isEqualToString:@"1"]) {
        self.chooseBtn.selected = YES;
        NSString *str = [NSString stringWithFormat:@"[默认]%@%@",model.area_info,model.address];
        NSMutableAttributedString * mustr = [[NSMutableAttributedString alloc]initWithString:str];
        [mustr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#E4393C"] range:NSMakeRange(0, 4)];
        [mustr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(4, mustr.length - 4)];
        self.areaLab.attributedText = mustr;

    }else{
        self.chooseBtn.selected = NO;
        self.areaLab.text = [NSString stringWithFormat:@"%@%@",model.area_info,model.address];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

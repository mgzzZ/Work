//
//  DanmakuCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DanmakuCell.h"

@implementation DanmakuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTempDanmaku:(NSAttributedString *)tempDanmaku
{
    self.danmakuL.attributedText = tempDanmaku;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

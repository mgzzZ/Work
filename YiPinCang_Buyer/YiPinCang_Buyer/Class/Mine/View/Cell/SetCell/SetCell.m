//
//  SetCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    self.icon = [[UIImageView alloc]init];
    [self.contentView addSubview:self.icon];
    self.icon.sd_layout
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,15);
    self.nextImg = [[UIImageView alloc]initWithImage:IMAGE(@"mine_icon_more")];
    [self.contentView addSubview:self.nextImg];
    self.nextImg.sd_layout
    .rightSpaceToView(self.contentView,15)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(self.contentView);
    self.nameLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLab];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = [UIFont systemFontOfSize:15];
    self.nameLab.textColor = [UIColor blackColor];
    self.nameLab.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.icon,15)
    .bottomEqualToView(self.contentView)
    .rightSpaceToView(self.nextImg,20);
    self.switchBtn = [[UISwitch alloc]init];
    [self.contentView addSubview:self.switchBtn];
    self.switchBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .widthIs(51)
    .heightIs(34);
    self.switchBtn.hidden = YES;
    self.countLab = [[UILabel alloc]init];
    self.countLab.textAlignment = NSTextAlignmentRight;
    self.countLab.font = [UIFont systemFontOfSize:15];
    self.countLab.textColor = [Color colorWithHex:@"BFBFBF"];
    [self.contentView addSubview:self.countLab];
    self.countLab.hidden = YES;
    self.countLab.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .heightIs(47);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

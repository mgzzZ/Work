//
//  DiscoverFiterCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverFiterCell.h"

@implementation DiscoverFiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.seleteImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_icon_selected")];
        self.seleteImg.hidden = YES;
        [self.contentView addSubview:self.seleteImg];
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLab];
        self.seleteImg.sd_layout
        .rightSpaceToView(self.contentView,15)
        .centerYEqualToView(self.contentView)
        .widthIs(25)
        .heightIs(25);
        self.titleLab.sd_layout
        .leftSpaceToView(self.contentView,15)
        .rightSpaceToView(self.seleteImg,15)
        .centerYEqualToView(self.contentView)
        .heightIs(15);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




@end

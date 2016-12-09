//
//  LiveDetailLiveShareCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLiveShareCell.h"

@implementation LiveDetailLiveShareCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.timeImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.timeImg];
    self.timeImg.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .widthIs(12)
    .heightIs(12);
    [self.timeImg setSd_cornerRadiusFromWidthRatio:@0.5];
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = [Color colorWithHex:@"0x3b3b3b"];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView,80)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,25)
    .autoHeightRatio(0);
    
    self.bgImgView = [[PhotoContainerView alloc]init];
    [self.contentView addSubview:self.bgImgView];
    self.bgImgView.sd_layout
    .leftEqualToView(self.titleLab);
    self.paycountLab = [[UILabel alloc]init];
    self.paycountLab.textAlignment = NSTextAlignmentLeft;
    self.paycountLab.font = [UIFont systemFontOfSize:15];
    self.paycountLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    [self.contentView addSubview:self.paycountLab];
    self.paycountLab.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.bgImgView,10)
    .widthIs(86)
    .heightIs(15);
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    self.priceLab.textColor = [Color colorWithHex:@"#E4393C"];
    [self.contentView addSubview:self.priceLab];
    self.priceLab.sd_layout
    .leftSpaceToView(self.paycountLab,5)
    .topSpaceToView(self.bgImgView,10)
    .widthIs(86)
    .heightIs(15);
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_likes")];
    [self.contentView addSubview:self.likeImg];
    self.likeImg.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.paycountLab,15)
    .widthIs(25)
    .heightIs(25);
    self.likecountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.likecountLab];
    self.likecountLab.textAlignment = NSTextAlignmentLeft;
    self.likecountLab.font = [UIFont systemFontOfSize:13];
    self.likecountLab.textColor = [Color colorWithHex:@"#2C2C2C"];
    self.likecountLab.sd_layout
    .leftSpaceToView(self.likeImg,5)
    .centerYEqualToView(self.likeImg)
    .heightIs(15)
    .widthIs(70);
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_commentnumber")];
    [self.contentView addSubview:self.commentImg];
    self.commentImg.sd_layout
    .leftEqualToView(self.priceLab)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(self.likeImg);
    self.commentcountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.likecountLab];
    self.commentcountLab.textAlignment = NSTextAlignmentLeft;
    self.commentcountLab.font = [UIFont systemFontOfSize:13];
    self.commentcountLab.textColor = [Color colorWithHex:@"#2C2C2C"];
    self.commentcountLab.sd_layout
    .leftSpaceToView(self.commentImg,5)
    .centerYEqualToView(self.likeImg)
    .heightIs(15)
    .widthIs(70);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"去购买" forState:UIControlStateNormal];
    [btn setTitleColor:[Color colorWithHex:@"#E4393C"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.borderColor = [Color colorWithHex:@"#E4393C"].CGColor;
    [self.contentView addSubview:btn];
    btn.sd_layout
    .rightEqualToView(self.titleLab)
    .centerYEqualToView(self.likeImg)
    .widthIs(72)
    .heightIs(24);
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.contentView addSubview:lineview];
    lineview.sd_layout
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(1)
    .topSpaceToView(self.likeImg,15);
    
    [self setupAutoHeightWithBottomView:lineview bottomMargin:0];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.contentView addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(self.contentView,21)
    .topSpaceToView(self.timeImg,0)
    .bottomSpaceToView(lineview,0)
    .widthIs(1);
    
    self.toplineView = [[UIView alloc]init];
    self.toplineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.contentView addSubview:self.toplineView];
    self.toplineView.sd_layout
    .leftSpaceToView(self.contentView,21)
    .topEqualToView(self.contentView)
    .widthIs(1)
    .bottomSpaceToView(self.timeImg,0);
}
- (void)setModel:(LiveShareModel *)model{
    self.titleLab.text = model.strace_title;
    if (model.strace_content.count == 1) {
        self.bgImgView.WH = model.aspect.floatValue;
    }
    self.bgImgView.picPathStringsArray = model.strace_content;
    self.bgImgView.sd_layout.topSpaceToView(self.titleLab,10);
    self.paycountLab.text = [NSString stringWithFormat:@"已售%@件",model.salenum];
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.likecountLab.text = model.strace_cool;
    self.commentcountLab.text = model.strace_comment;
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

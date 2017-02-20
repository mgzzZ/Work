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
    .topSpaceToView(self.contentView,20)
    .widthIs(12)
    .heightIs(12);
    [self.timeImg setSd_cornerRadiusFromWidthRatio:@0.5];
    
    
   
    
    
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = [Color colorWithHex:@"0x3b3b3b"];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont fontWithName:@"SimSun" size:15];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView,80)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,25)
    .autoHeightRatio(0);
    
    
    
    self.timeLab = [[UILabel alloc]init];
  
    self.timeLab.font = YPCPFFont(15);
    self.timeLab.textColor = [Color colorWithHex:@"#2c2c2c"];
    [self.contentView addSubview:self.timeLab];
    self.timeLab.sd_layout
    .leftSpaceToView(self.timeImg,5)
    .topEqualToView(self.titleLab)
    .rightSpaceToView(self.titleLab,5)
    .heightIs(20);
    
    self.bgImgView = [[PhotoContainerView alloc]init];
    [self.contentView addSubview:self.bgImgView];
    self.bgImgView.sd_layout
    .leftEqualToView(self.titleLab);
    
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.font = YPCPFFont(15);
    self.priceLab.textColor = [Color colorWithHex:@"#E4393C"];
    [self.contentView addSubview:self.priceLab];
    self.priceLab.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.bgImgView,10)
    .widthIs(86)
    .heightIs(15);
    
    self.originalpriceLab = [[OriginalPriceLab alloc]init];
    [self.contentView addSubview:self.originalpriceLab];
    self.originalpriceLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    self.originalpriceLab.lineColor = [Color colorWithHex:@"#BFBFBF"];
    self.originalpriceLab.textAlignment = NSTextAlignmentLeft;
    self.originalpriceLab.font = YPCPFFont(15);
    self.originalpriceLab.sd_layout
    .leftSpaceToView(self.priceLab,20)
    .centerYEqualToView(self.priceLab)
    .heightIs(15);
    
    
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
    .centerYEqualToView(self.priceLab)
    .widthIs(72)
    .heightIs(24);
    
    self.commentcountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.commentcountLab];
    self.commentcountLab.textAlignment = NSTextAlignmentRight;
    self.commentcountLab.font = YPCPFFont(13);
    self.commentcountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.commentcountLab.sd_layout
    .rightEqualToView(self.titleLab)
    .topSpaceToView(btn,15)
    .heightIs(15);
    
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_pinglun_button")];
    [self.contentView addSubview:self.commentImg];
    self.commentImg.sd_layout
    .rightSpaceToView(self.commentcountLab,5)
    .widthIs(19)
    .heightIs(19)
    .centerYEqualToView(self.commentcountLab);
    
    self.likecountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.likecountLab];
    self.likecountLab.textAlignment = NSTextAlignmentLeft;
    self.likecountLab.font = YPCPFFont(13);
    self.likecountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.likecountLab.sd_layout
    .rightSpaceToView(self.commentImg,34)
    .centerYEqualToView(self.commentcountLab)
    .heightIs(15);
    
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_like_button")];
    [self.contentView addSubview:self.likeImg];
    self.likeImg.sd_layout
    .rightSpaceToView(self.likecountLab,5)
    .centerYEqualToView(self.commentcountLab)
    .widthIs(19)
    .heightIs(19);
    
    self.paycountLab = [[UILabel alloc]init];
    self.paycountLab.textAlignment = NSTextAlignmentLeft;
    self.paycountLab.font = YPCPFFont(12);
    self.paycountLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    [self.contentView addSubview:self.paycountLab];
    self.paycountLab.sd_layout
    .leftEqualToView(self.titleLab)
    .centerYEqualToView(self.commentcountLab)
    .widthIs(86)
    .heightIs(15);
    
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
    [self.priceLab sizeToFit];
    self.priceLab.sd_layout
    .widthIs(self.priceLab.frame.size.width);
    self.likecountLab.text = model.strace_cool;
    [self.likecountLab sizeToFit];
    self.likecountLab.sd_layout.widthIs(self.likecountLab.frame.size.width);
    self.commentcountLab.text = model.strace_comment;
    [self.commentcountLab sizeToFit];
    self.commentcountLab.sd_layout.widthIs(self.commentcountLab.frame.size.width);
    self.timeLab.text = model.strace_time;
    self.originalpriceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_marketprice];
    [self.originalpriceLab sizeToFit];
    self.originalpriceLab.sd_layout.widthIs(self.originalpriceLab.frame.size.width);
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

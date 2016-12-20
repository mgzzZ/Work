//
//  BranCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BranCell.h"

@implementation BranCell

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
   
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor= [Color colorWithHex:@"0xe3e3e3"];
    view.alpha = 0.72;
    [self.contentView addSubview:view];
    view.sd_layout
    .widthIs(23)
    .heightIs(11)
    .topSpaceToView(self.contentView,22.5)
    .leftSpaceToView(self.contentView,7.5);
    self.numberLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.numberLab];
    self.numberLab.textColor = [Color colorWithHex:@"#f00e3a"];
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
    self.numberLab.sd_layout
    .topSpaceToView(self.contentView,14)
    .leftEqualToView(self.contentView)
    .heightIs(20)
    .widthIs(54.5);
    self.nameLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLab];
    self.nameLab.font = [UIFont systemFontOfSize:17];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.sd_layout
    .leftSpaceToView(self.numberLab,0)
    .topEqualToView(self.numberLab)
    .rightEqualToView(self.contentView)
    .autoHeightRatio(0);
    
    self.bgImgView = [[PhotoContainerView alloc]init];
    [self.contentView addSubview:self.bgImgView];
    self.bgImgView.sd_layout.leftSpaceToView(self.numberLab,0);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [Color colorWithHex:@"0xe4e4e4"];
    [self.contentView addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(self.bgImgView)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.bgImgView,37.5)
    .heightIs(1);
    
    self.timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLab];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    self.timeLab.textColor = [Color colorWithHex:@"#666666"];
    self.timeLab.font = [UIFont systemFontOfSize:12];
    self.timeLab.sd_layout
    .leftEqualToView(self.nameLab)
    .topSpaceToView(self.bgImgView,0)
    .bottomSpaceToView(lineView,0);
    
    
    self.likeCountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.likeCountLab];
    self.likeCountLab.textAlignment = NSTextAlignmentRight;
    self.likeCountLab.textColor = [Color colorWithHex:@"0x666666"];
    self.likeCountLab.font = [UIFont systemFontOfSize:12];
    self.likeCountLab.sd_layout
    .rightSpaceToView(self.contentView,15)
    .heightIs(15)
    .centerYEqualToView(self.timeLab);
    
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_like_icon")];
    [self.contentView addSubview:self.likeImg];
    self.likeImg.sd_layout
    .widthIs(19)
    .heightIs(19)
    .centerYEqualToView(self.timeLab)
    .rightSpaceToView(self.likeCountLab,5);
    
    self.commontCountLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.commontCountLab];
    self.commontCountLab.textAlignment = NSTextAlignmentRight;
    self.commontCountLab.textColor = [Color colorWithHex:@"0x666666"];
    self.commontCountLab.font = [UIFont systemFontOfSize:12];
    self.commontCountLab.sd_layout
    .rightSpaceToView(self.likeImg,15)
    .heightIs(15)
    .centerYEqualToView(self.timeLab);
    
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_pinglun_icon")];
    [self.contentView addSubview:self.commentImg];
    self.commentImg.sd_layout
    .widthIs(19)
    .heightIs(19)
    .centerYEqualToView(self.timeLab)
    .rightSpaceToView(self.commontCountLab,5);
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payBtn setImage:IMAGE(@"find_button") forState:UIControlStateNormal];
    [self.contentView addSubview:self.payBtn];
    self.payBtn.sd_layout
    .widthIs(105)
    .heightIs(36.5)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(lineView,21.5);
    
    
    self.priceLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.priceLab];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.font = [UIFont systemFontOfSize:21];
    self.priceLab.textColor = [Color colorWithHex:@"#F00E3A"];
    self.priceLab.sd_layout
    .leftEqualToView(self.nameLab)
    .rightSpaceToView(self.payBtn,10)
    .topSpaceToView(lineView,17)
    .heightIs(24.5);
    
    UIImageView *img = [[UIImageView alloc]initWithImage:IMAGE(@"find_ssle_icon")];
    [self.contentView addSubview:img];
    img.sd_layout
    .leftEqualToView(self.priceLab)
    .topSpaceToView(self.priceLab,5)
    .widthIs(122)
    .heightIs(15.5);
    
    self.countView = [[UIView alloc]init];
    self.countView.backgroundColor = [Color colorWithHex:@"#f00e3a"];
    self.countView.layer.cornerRadius = 7.75;
    [self.contentView addSubview:self.countView];
    self.countView.sd_layout
    .leftEqualToView(img)
    .topEqualToView(img)
    .bottomEqualToView(img);
    
    self.countLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.countLab];
    self.countLab.textAlignment = NSTextAlignmentLeft;
    self.countLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.countLab.textColor = [Color colorWithHex:@"#f00e3a"];
    self.countLab.sd_layout
    .leftSpaceToView(self.priceLab,5)
    .rightEqualToView(img)
    .topEqualToView(img)
    .bottomEqualToView(img);
    
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
    [self.contentView addSubview:bottomView];
    bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10)
    .topSpaceToView(self.payBtn,23.5);
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
    
}
- (void)setModel:(LiveActivityModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.nameLab.text = model.strace_title;
    self.priceLab.text = [NSString stringWithFormat:@"¥ %@",model.goods_price];
    if (model.strace_content.count == 1) {
        self.bgImgView.WH = model.aspect.floatValue;
        self.bgImgView.picPathStringsArray = model.strace_content;
    }else{
        self.bgImgView.picPathStringsArray = model.strace_content;
    }
    self.bgImgView.sd_layout.topSpaceToView(self.nameLab,10);
    self.likeCountLab.text = model.strace_cool;
    [self.likeCountLab sizeToFit];
    self.likeCountLab.sd_layout.widthIs(self.likeCountLab.frame.size.width);
    self.commontCountLab.text = model.strace_comment;
    [self.commontCountLab sizeToFit];
    self.commontCountLab.sd_layout.widthIs(self.commontCountLab.frame.size.width);
    self.numberLab.text = model.goods_serial;
    self.timeLab.text = model.goods_uptime;
    
    CGFloat width = (model.salenum.floatValue / model.storage.floatValue) * 122;
    self.countView.sd_layout.widthIs(width);
    self.countLab.text = [NSString stringWithFormat:@"已抢购 %@件",model.salenum];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

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
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    self.bgImgView = [[PhotoContainerView alloc]init];
    [self.contentView addSubview:self.bgImgView];
    self.bgImgView.containerType = PhotoContainerTypeFindScreenWidth;
    self.bgImgView.modeType = PhotoContainerModeTypeHave;
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
    .rightSpaceToView(self.contentView,44 + 5)
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
    .rightSpaceToView(self.likeImg,15 + 5)
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
    self.payBtn.userInteractionEnabled = NO;
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
    self.priceLab.font = [UIFont systemFontOfSize:18];
    self.priceLab.textColor = [Color colorWithHex:@"#333333"];
    self.priceLab.sd_layout
    .leftEqualToView(self.nameLab)
    .rightSpaceToView(self.payBtn,10)
    .topSpaceToView(lineView,10)
    .heightIs(20);
    
    
    self.originalLab = [[OriginalPriceLab alloc]init];
    [self.contentView addSubview:self.originalLab];
    self.originalLab.textAlignment = NSTextAlignmentLeft;
    self.originalLab.font = YPCPFFont(12);
    self.originalLab.textColor = [Color colorWithHex:@"0xbfbfbf"];
    self.originalLab.sd_layout
    .leftEqualToView(self.priceLab)
    .topSpaceToView(self.priceLab,5)
    .heightIs(15);
    
    self.countLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.countLab];
    self.countLab.textAlignment = NSTextAlignmentCenter;
    self.countLab.font = [UIFont systemFontOfSize:11];
    self.countLab.textColor = [Color colorWithHex:@"#f00e3a"];
    self.countLab.sd_layout
    .leftEqualToView(self.priceLab)
    .widthIs(122)
    .topSpaceToView(self.originalLab,5)
    .heightIs(15.5);
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setImage:IMAGE(@"huodongpage_share_icon") forState:UIControlStateNormal];
    [self.contentView addSubview:self.shareBtn];
    self.shareBtn.sd_layout
    .rightSpaceToView(self.contentView,0)
    .widthIs(44)
    .heightIs(44)
    .centerYEqualToView(self.timeLab);
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
    [self.contentView addSubview:bottomView];
    bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10)
    .topSpaceToView(self.countLab,11.5);
    
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
        self.bgImgView.thumbPicPathStringsArray = model.strace_content_thumb;
    }else{
        self.bgImgView.picPathStringsArray = model.strace_content;
        self.bgImgView.thumbPicPathStringsArray = model.strace_content_thumb;
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
    self.originalLab.text = [NSString stringWithFormat:@"¥%@",model.goods_marketprice];
    [self.originalLab sizeToFit];
    self.originalLab.sd_layout.widthIs(self.originalLab.frame.size.width);
    if (_gradientView) {
        [_gradientView removeFromSuperview];
    }
    self.gradientView = [[GradientView alloc]init];
    self.gradientView.fillColor = [Color colorWithHex:@"#FCC6D1"];
    self.gradientView.fromColor = [Color colorWithHex:@"#F5C6CD"];
    self.gradientView.toColor = [Color colorWithHex:@"#FBDCD5"];
    [self.contentView addSubview:self.gradientView];
    self.gradientView.sd_layout
    .leftEqualToView(self.priceLab)
    .topSpaceToView(self.originalLab,5)
    .widthIs(122)
    .heightIs(15.5);
    [self.contentView sendSubviewToBack:self.gradientView];
    if (model.storage.floatValue == 0) {
        [self.payBtn setImage:IMAGE(@"find_button1") forState:UIControlStateNormal];
    }else{
        [self.payBtn setImage:IMAGE(@"find_button") forState:UIControlStateNormal];
       
    }
    CGFloat width = 0;
    if (model.storage.floatValue + model.salenum.floatValue > 0) {
        width = (model.salenum.floatValue / (model.storage.floatValue + model.salenum.floatValue)) * 122;
    }
    
    self.gradientView.gradientWidth = width;
    self.countLab.text = [NSString stringWithFormat:@"已抢购 %@件",model.salenum];
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

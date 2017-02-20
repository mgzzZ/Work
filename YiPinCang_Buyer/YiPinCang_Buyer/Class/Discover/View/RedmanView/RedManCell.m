//
//  RedManCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "RedManCell.h"



@implementation RedManCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [Color colorWithHex:@"0xf2f2f2"];
        CGFloat ImgHeight  = (ScreenWidth - 36) / 3;
        self.bgView.sd_layout
        .leftSpaceToView(self.contentView,7)
        .topEqualToView(self.contentView)
        .rightSpaceToView(self.contentView,7)
        .heightIs(ImgHeight + 141);
        
        UIImageView *txBgview = [[UIImageView alloc]initWithImage:IMAGE(@"find_border_icon")];
       
        [self.bgView addSubview:txBgview];
        txBgview.sd_layout
        .centerXEqualToView(self.bgView)
        .topSpaceToView(self.bgView,13)
        .widthIs(70)
        .heightIs(70);
        [txBgview setSd_cornerRadiusFromWidthRatio:@0.5];
        self.txImg.sd_layout
        .centerXEqualToView(self.bgView)
        .widthIs(66)
        .heightIs(66)
        .topSpaceToView(self.bgView,15);
        [self.txImg setSd_cornerRadiusFromWidthRatio:@0.5];
        self.nameLab.sd_layout
        .leftSpaceToView(self.bgView,15)
        .rightSpaceToView(self.bgView,15)
        .topSpaceToView(txBgview,0)
        .heightIs(20);
        self.countLab.sd_layout
        .heightIs(15)
        .topSpaceToView(self.nameLab,7)
        .leftSpaceToView(self.bgView,15)
        .rightSpaceToView(self.bgView,15);
        
        for (int i = 0; i < 3; i++) {
            UIImageView *img = [[UIImageView alloc]init];
            img.contentMode =UIViewContentModeScaleAspectFill;
            img.clipsToBounds = YES;
            [self.bgView addSubview:img];
            img.tag = 1000 + i;
            img.sd_layout
            .widthIs(ImgHeight)
            .heightIs(ImgHeight)
            .xIs(6 + (ImgHeight + 6) * i)
            .topSpaceToView(self.countLab,7);
        }
        self.lineView.sd_layout
        .leftEqualToView(self.contentView)
        .topSpaceToView(self.bgView,0)
        .heightIs(7)
        .rightSpaceToView(self.contentView,0);
        [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
    }
    return self;
}

- (void)setModel:(RedManModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.nameLab.text = model.store_name;
    self.countLab.text = [NSString stringWithFormat:@"%@人在关注",model.store_collect];
    for (int i = 0; i < model.storeimg.count; i++) {
        UIImageView *img = (UIImageView *)[self.contentView viewWithTag:1000 + i];
        [img sd_setImageWithURL:[NSURL URLWithString:model.storeimg[i]] placeholderImage:YPCImagePlaceHolder];
    }
}


- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 2;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)txImg{
    if (_txImg == nil) {
        _txImg = [[UIImageView alloc]init];
        [self.bgView addSubview:_txImg];
    }
    return _txImg;
}

- (UILabel *)nameLab{
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font= [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _nameLab.textColor = [Color colorWithHex:@"0x333333"];
        [self.bgView addSubview:_nameLab];
    }
    return _nameLab;
}

- (UILabel *)countLab{
    if (_countLab == nil) {
        _countLab = [[UILabel alloc]init];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.font= YPCPFFont(13);
        _countLab.textColor = [Color colorWithHex:@"0x999999"];
        [self.bgView addSubview:_countLab];
    }
    return _countLab;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [Color colorWithHex:@"0xf2f2f2"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
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

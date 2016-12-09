//
//  LiveDetailLiveNoteOfImgCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/2.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLiveNoteOfImgCell.h"

@implementation LiveDetailLiveNoteOfImgCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = [Color colorWithHex:@"#2C2C2C"];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    self.bgImgView = [[PhotoContainerView alloc]init];
    [self.contentView addSubview:self.bgImgView];
    self.bgImgView.sd_layout
    .leftEqualToView(self.titleLab);
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLab];
    self.timeLab.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.bgImgView,10)
    .heightIs(15);
    self.commentLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.commentLab];
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.commentLab.font = [UIFont systemFontOfSize:13];
    self.commentLab.sd_layout
    .rightEqualToView(self.titleLab)
    .topSpaceToView(self.timeLab,5)
    .heightIs(15);
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_commentnumber")];
    [self.contentView addSubview:self.commentImg];
    self.commentImg.sd_layout
    .widthIs(25)
    .heightIs(25)
    .rightSpaceToView(self.commentLab,5)
    .centerYEqualToView(self.commentLab);
    
    self.likeLab = [[UILabel alloc]init];
    self.likeLab.textAlignment = NSTextAlignmentRight;
    self.likeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.likeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.likeLab];
    self.likeLab.sd_layout
    .rightSpaceToView(self.commentImg,30)
    .centerYEqualToView(self.commentLab)
    .heightIs(15);
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_likes")];
    [self.contentView addSubview:self.likeImg];
    self.likeImg.sd_layout
    .rightSpaceToView(self.likeLab,5)
    .centerYEqualToView(self.commentLab)
    .widthIs(25)
    .heightIs(25);
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.contentView addSubview:view];
    view.sd_layout
    .leftEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,0)
    .heightIs(7)
    .topSpaceToView(self.likeImg,15);
    [self setupAutoHeightWithBottomView:view bottomMargin:0];
}
- (void)setModel:(LiveNoteModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.titleLab.text = model.strace_title;
    if (model.strace_content.count == 1) {
        self.bgImgView.WH = model.aspect.floatValue;
    }
    self.bgImgView.picPathStringsArray = model.strace_content;
    self.bgImgView.sd_layout.topSpaceToView(self.titleLab,10);
    NSString *time = [YPC_Tools timeWithTimeIntervalString:model.strace_time Format:@"YYYY-MM-dd"];
    self.timeLab.text = time;
    [self.timeLab sizeToFit];
    self.timeLab.sd_layout.widthIs(self.timeLab.frame.size.width);
    self.likeLab.text = model.strace_cool;
    self.commentLab.text = model.strace_comment;
    [self.likeLab sizeToFit];
    [self.commentLab sizeToFit];
    self.likeLab.sd_layout.widthIs(self.likeLab.size.width);
    self.commentLab.sd_layout.widthIs(self.commentLab.size.width);
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

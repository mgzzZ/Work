//
//  DiscoverCommentCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverCommentCell.h"

@implementation DiscoverCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        self.txImg = [[UIImageView alloc]init];
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.textColor = [Color colorWithHex:@"0x448aca"];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = [UIFont systemFontOfSize:15];
        self.timeLab = [[UILabel alloc]init];
        self.timeLab.font = [UIFont systemFontOfSize:10];
        self.timeLab.textAlignment = NSTextAlignmentRight;
        self.timeLab.textColor = [Color colorWithHex:@"BFBFBF"];
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.textColor = [Color colorWithHex:@"0x000000"];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.numberOfLines = 0;
        [self.contentView sd_addSubviews:@[self.bgView]];
        self.bgView.sd_layout
        .leftSpaceToView(self.contentView,15)
        .rightSpaceToView(self.contentView,15)
        .topEqualToView(self.contentView);
        [self.bgView sd_addSubviews:@[self.nameLab,self.txImg,self.timeLab,self.titleLab]];
        
       
        self.txImg.sd_layout
        .leftSpaceToView(self.bgView,45)
        .topSpaceToView(self.bgView,15)
        .widthIs(34)
        .heightIs(34);
    
        
        [self.txImg setSd_cornerRadiusFromWidthRatio:@0.5];
        
        self.txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.txBtn];
        self.txBtn.sd_layout
        .leftEqualToView(self.txImg)
        .rightEqualToView(self.txImg)
        .topEqualToView(self.txImg)
        .bottomEqualToView(self.txImg);
        
        self.timeLab.sd_layout
        .rightSpaceToView(self.bgView,10)
        .heightIs(15)
        .topSpaceToView(self.bgView,10);
        self.nameLab.sd_layout
        .leftSpaceToView(self.txImg,5)
        .rightSpaceToView(self.timeLab,10)
        .topEqualToView(self.txImg)
        .heightIs(15);
        self.titleLab.sd_layout
        .leftSpaceToView(self.txImg,5)
        .rightSpaceToView(self.bgView,10)
        .topSpaceToView(self.nameLab,5)
        .autoHeightRatio(0);
        
        
        
    }
    return self;
}
- (void)setModel:(CommentListModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.scomm_memberavatar] placeholderImage:YPCImagePlaceHolder];
    NSString *time = [YPC_Tools timeWithTimeIntervalString:model.scomm_time Format:@"YYYY-MM-dd HH:mm"];
    
    self.timeLab.text = time;
    [self.timeLab sizeToFit];
    self.timeLab.sd_layout.widthIs(self.timeLab.frame.size.width);
    if ([model.comment_type isEqualToString:@"3"]) {
        NSString *huifuStr = [NSString stringWithFormat:@"%@回复%@",model.scomm_membername,model.scommto_membername];
 
        NSMutableAttributedString *name = [[NSMutableAttributedString alloc]initWithString:huifuStr];
        [name addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#0071BA"] range:NSMakeRange(0,model.scomm_membername.length)];
        [name addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"0x2c2c2c"] range:NSMakeRange(model.scomm_membername.length,2)];
        [name addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#0071BA"] range:NSMakeRange(model.scomm_membername.length + 2 ,model.scommto_membername.length)];
        self.nameLab.attributedText = name;
        
    }else{
        self.nameLab.text = model.scomm_membername;
    }
    self.titleLab.text = model.scomm_content;
    
    [self.bgView setupAutoHeightWithBottomView:self.titleLab bottomMargin:10];
    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0];
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

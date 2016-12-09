//
//  DiscoverCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverCell.h"

@implementation DiscoverCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setup{
    self.isAsyan = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    UIImageView *img = [[UIImageView alloc]initWithImage:IMAGE(@"find_img_redbj_avatar")];
    img.backgroundColor = [UIColor whiteColor];
    self.txImg = [[UIImageView alloc]init];
    self.txImg.backgroundColor = [UIColor whiteColor];
    
    UIButton *txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [txBtn addTarget:self action:@selector(txBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nameLab = [[YYLabel alloc]init];
    self.nameLab.backgroundColor = [UIColor whiteColor];
    self.nameLab.font = [UIFont systemFontOfSize:16];
    self.nameLab.displaysAsynchronously = self.isAsyan;
    self.nameLab.textColor = [Color colorWithHex:@"0x3b3b3b"];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.titlelab  = [[YYLabel alloc]init];
    self.titlelab.font = [UIFont systemFontOfSize:15];
    self.titlelab.backgroundColor = [UIColor whiteColor];
    self.titlelab.textColor = [Color colorWithHex:@"0x3b3b3b"];
    self.titlelab.numberOfLines = 0;
    self.titlelab.textAlignment = NSTextAlignmentLeft;
    self.titlelab.displaysAsynchronously = self.isAsyan;
    self.gudingLab = [[UILabel alloc]init];
    self.gudingLab.font = [UIFont systemFontOfSize:9];
    self.gudingLab.textColor = [UIColor whiteColor];
    self.gudingLab.text = @"直播组";
    self.gudingLab.textAlignment = NSTextAlignmentCenter;
    self.bgImgView = [[PhotoContainerView alloc]init];
    
    self.bgImgView.backgroundColor =[UIColor whiteColor];
    self.lableView = [[YYLabel alloc]init];
    self.lableView.backgroundColor = [UIColor whiteColor];
    self.lableView.numberOfLines = 0;
    self.lableView.displaysAsynchronously = self.isAsyan;

    self.timeLab = [[YYLabel alloc]init];
    self.timeLab.backgroundColor = [UIColor whiteColor];
    self.timeLab.displaysAsynchronously = self.isAsyan;
    self.timeLab.font = [UIFont systemFontOfSize:12];
    self.timeLab.textColor = [Color colorWithHex:@"0xcdcdcd"];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    self.likeLab = [[UILabel alloc]init];
    self.likeLab.textAlignment = NSTextAlignmentRight;
    self.likeLab.opaque = YES;
    self.likeLab.backgroundColor = [UIColor whiteColor];
    //self.likeLab.displaysAsynchronously = YES;
    self.likeLab.font = [UIFont systemFontOfSize:10];
    self.likeLab.textColor = [UIColor blackColor];
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_icon_good")];
    self.likeImg.opaque = YES;
    self.commentLab = [[UILabel alloc]init];
   // self.commentLab.displaysAsynchronously = YES;
    self.commentLab.opaque = YES;
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.font = [UIFont systemFontOfSize:10];
    self.commentLab.textColor = [UIColor blackColor];
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_icon_comment")];
    self.commentImg.opaque = YES;
    
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textColor = [Color colorWithHex:@"0xE4393C"];
    self.priceLab.font = [UIFont systemFontOfSize:13];
    self.priceLab.textAlignment = NSTextAlignmentRight;
    
    
    self.payCountLab = [[UILabel alloc]init];
    self.payCountLab.textColor = [Color colorWithHex:@"0xbfbfbf"];
    self.payCountLab.font = [UIFont systemFontOfSize:13];
    self.payCountLab.textAlignment = NSTextAlignmentRight;
    
    self.typeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_icon_pre_sale")];
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.backgroundColor = [UIColor redColor];
    [self.payBtn setTitle:@"购买" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.payBtn.layer.cornerRadius = 2;
    [self.contentView sd_addSubviews:@[img,self.txImg,self.nameLab,self.titlelab,self.bgImgView,self.lableView,self.timeLab,self.likeLab,self.likeImg,self.commentLab,self.commentImg,view,self.gudingLab,self.priceLab,self.payCountLab,self.typeImg,self.payBtn,txBtn]];
    view.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(7);
    img.sd_layout
    .leftSpaceToView(self.contentView,6)
    .widthIs(55)
    .heightIs(50)
    .topSpaceToView(view,0);
    
    self.typeImg.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,7)
    .widthIs(68)
    .heightIs(22);
    
    self.txImg.sd_layout
    .bottomEqualToView(img)
    .centerXEqualToView(img)
    .widthIs(40)
    .heightIs(40);
    
    self.txImg.layer.cornerRadius = 20;
    self.txImg.layer.masksToBounds = YES;
    txBtn.sd_layout
    .leftEqualToView(self.txImg)
    .rightEqualToView(self.txImg)
    .topEqualToView(self.txImg)
    .bottomEqualToView(self.txImg);
    self.gudingLab.sd_layout
    .topEqualToView(img)
    .centerXEqualToView(img)
    .heightIs(10)
    .widthIs(55);
    self.nameLab.sd_layout
    .leftSpaceToView(img,6)
    .topSpaceToView(view,6)
    .rightEqualToView(self.contentView)
    .heightIs(15);
    self.titlelab.sd_layout
    .leftEqualToView(self.nameLab)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.nameLab,5);
    self.bgImgView.sd_layout.leftEqualToView(self.nameLab);
    
    
    self.priceLab.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.bgImgView,30)
    .heightIs(15);
    
    self.payCountLab.sd_layout
    .rightSpaceToView(self.priceLab,15)
    .topEqualToView(self.priceLab)
    .heightIs(15);
    
    
    self.lableView.sd_layout
    .leftEqualToView(self.nameLab)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.bgImgView,10);
    
    self.likeLab.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.priceLab,10)
    .heightIs(15);
    
    self.likeImg.sd_layout
    .centerYEqualToView(self.likeLab)
    .rightSpaceToView(self.likeLab,5)
    .widthIs(20)
    .heightIs(20);
    self.commentLab.sd_layout
    .rightSpaceToView(self.likeImg,10)
    .heightIs(15)
    .centerYEqualToView(self.likeImg);
    self.commentImg.sd_layout
    .widthIs(20)
    .heightIs(20)
    .rightSpaceToView(self.commentLab,5)
    .centerYEqualToView(self.likeImg);
    self.timeLab.sd_layout
    .centerYEqualToView(self.likeImg)
    .leftEqualToView(self.nameLab)
    .heightIs(15);
    self.payBtn.sd_layout
    .leftSpaceToView(self.timeLab,0)
    .centerYEqualToView(self.timeLab)
    .widthIs(64)
    .heightIs(23);
}
- (void)setModel:(DiscoverLivegoodsModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.strace_storelogo] placeholderImage:YPCImagePlaceHolder];
    self.nameLab.text = model.strace_storename;
    self.titlelab.text = model.strace_title;
    if (model.strace_content.count == 1) {
        self.bgImgView.WH = model.aspect.floatValue;
    }
    self.bgImgView.picPathStringsArray = model.strace_content;
    self.bgImgView.sd_layout.topSpaceToView(self.titlelab,10);
    self.likeLab.text = model.strace_cool;
    self.commentLab.text = model.strace_comment;
    
    NSString *time = [YPC_Tools timeWithTimeIntervalString:model.strace_time Format:@"YYYY-MM-dd"];
    self.timeLab.text = time;
    if (model.label.count == 0) {
        self.lableView.sd_layout.heightIs(0);
        self.lableView.text = @"";
    }else{
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        UIFont *font = [UIFont systemFontOfSize:14];
        for (int i = 0; i < model.label.count; i++) {
            NSString *tag = model.label[i];
            UIColor *tagStrokeColor = [UIColor whiteColor];;
            UIColor *tagFillColor =[UIColor whiteColor];;
            NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
            [tagText yy_insertString:@"   " atIndex:0];
            [tagText yy_appendString:@"   "];
            tagText.yy_font = font;
            tagText.yy_color = [UIColor redColor];
            [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
            YYTextBorder *border = [YYTextBorder new];
            border.strokeWidth = 0;
            border.strokeColor = tagStrokeColor;
            border.fillColor = tagFillColor;
            border.cornerRadius = 100; // a huge value
            border.lineJoin = kCGLineJoinBevel;
            
            border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
            [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
            
            [text appendAttributedString:tagText];
        }
        self.lableView.sd_layout.heightIs(20);
        self.lableView.attributedText = text;
    }

    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    [self.priceLab sizeToFit];
    self.priceLab.sd_layout.widthIs(self.priceLab.size.width);
    self.payCountLab.text = [NSString stringWithFormat:@"已售%@件",model.salenum];
    [self.payCountLab sizeToFit];
    self.payCountLab.sd_layout.widthIs(self.payCountLab.frame.size.width);
    [self.likeLab sizeToFit];
    self.likeLab.sd_layout
    .widthIs(self.likeLab.frame.size.width);
    [self.commentLab sizeToFit];
    
    self.commentLab.sd_layout
    .widthIs(self.commentLab.frame.size.width);
    self.timeLab.sd_layout.widthIs(75);
    if ([model.prestate isEqualToString:@"1"]) {
        self.typeImg.hidden = NO;
    }else{
        self.typeImg.hidden = YES;
    }
    [self setupAutoHeightWithBottomView:self.commentLab bottomMargin:15];
    
}

- (void)txBtnClick{
    if (self.txBtnClickBlock) {
        self.txBtnClickBlock(_model.strace_storeid);
    }

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

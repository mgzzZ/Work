//
//  LiveTopView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveTopView.h"

@interface LiveTopView ()



@end

@implementation LiveTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.bgImg = [[UIImageView alloc]init];
    self.bgImg.userInteractionEnabled = YES;
    self.bgImg.frame = self.bounds;
    [self addSubview:self.bgImg];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.bgImg addSubview:bgView];
    bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.topImg = [[UIImageView alloc]init];
    [bgView addSubview:self.topImg];
    self.topImg.sd_layout
    .topEqualToView(bgView)
    .leftEqualToView(bgView)
    .rightEqualToView(bgView)
    .heightIs(kHeight(158));
    UIView *txView = [[UIView alloc]init];
    txView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:txView];
    txView.sd_layout
    .centerXEqualToView(bgView)
    .widthIs(kWidth(104))
    .heightIs(kWidth(104))
    .topSpaceToView(bgView,kHeight(95));
    
    self.txImg = [[UIImageView alloc]init];
    self.txImg.userInteractionEnabled = YES;
    [txView addSubview:self.txImg];
    self.txImg.sd_layout.spaceToSuperView(UIEdgeInsetsMake(3, 3, 3, 3));
    self.txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.txImg addSubview:self.txBtn];
    self.txBtn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont boldSystemFontOfSize:17];
    [bgView addSubview:self.nameLab];
    self.nameLab.sd_layout
    .leftEqualToView(bgView)
    .rightEqualToView(bgView)
    .topSpaceToView(txView,5)
    .heightIs(20);
    
    self.fansLab = [[UILabel alloc]init];
    self.fansLab.textAlignment = NSTextAlignmentCenter;
    self.fansLab.font = [UIFont systemFontOfSize:14];
    self.fansLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    [bgView addSubview:self.fansLab];
    self.fansLab.sd_layout
    .leftEqualToView(bgView)
    .rightEqualToView(bgView)
    .topSpaceToView(self.nameLab,5)
    .heightIs(20);
    self.fllowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.fllowBtn setImage:IMAGE(@"find_livestreaming_button") forState:UIControlStateNormal];
    [self.fllowBtn setImage:IMAGE(@"find_livestreaming_button2") forState:UIControlStateSelected];
    [bgView addSubview:self.fllowBtn];
    self.fllowBtn.sd_layout
    .widthIs(146)
    .heightIs(40)
    .centerXEqualToView(bgView)
    .topSpaceToView(self.fansLab,kHeight(15));
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.titleLab.font = [UIFont systemFontOfSize:14];
    [self.titleLab setNumberOfLines:2];
    [bgView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(bgView,20)
    .rightSpaceToView(bgView,20)
    .topSpaceToView(self.fllowBtn,kHeight(10))
    .heightIs(40);
    self.classLab = [[YYLabel alloc]init];
    self.classLab.textAlignment = NSTextAlignmentCenter;
    self.classLab.userInteractionEnabled = NO;
    [bgView addSubview:self.classLab];
    self.classLab.sd_layout
    .leftSpaceToView(bgView,20)
    .rightSpaceToView(bgView,20)
    .topSpaceToView(self.titleLab,kHeight(0))
    .heightIs(40);
   
}

- (void)setModel:(LiveTopViewModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.nameLab.text = model.store_name;
    self.titleLab.text = model.store_description;
    if ([model.is_follow isEqualToString:@"0"]) {
        self.fllowBtn.selected = NO;
    }else{
        self.fllowBtn.selected =YES;
    }

    
   
    if (model.label.count == 0) {
        self.classLab.sd_layout.heightIs(0);
        self.classLab.text = @"";
    }else{
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        UIFont *font = [UIFont systemFontOfSize:14];
        for (int i = 0; i < model.label.count; i++) {
            NSString *tag = model.label[i];
            UIColor *tagStrokeColor = [Color colorWithHex:@"0xcccccc"];
            UIColor *tagFillColor =[UIColor whiteColor];;
            NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
            [tagText yy_insertString:@"   " atIndex:0];
            [tagText yy_appendString:@"   "];
            tagText.yy_font = font;
            tagText.yy_color = [Color colorWithHex:@"0xcccccc"];
            [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
            YYTextBorder *border = [YYTextBorder new];
            border.strokeWidth = 1;
            border.strokeColor = tagStrokeColor;
            border.fillColor = tagFillColor;
            border.cornerRadius = 50; // a huge value
            border.lineJoin = kCGLineJoinBevel;
            border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
            [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
            
            [text appendAttributedString:tagText];
        }
        self.classLab.sd_layout.heightIs(40);
        self.classLab.attributedText = text;
    }
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.store_banner] placeholderImage:IMAGE(@"find_logo_placeholder")];
    self.fansLab.text = [NSString stringWithFormat:@"%@粉丝",model.store_collect];
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
    [self.bgImg setImage:IMAGE(@"shadow1")];
}

@end

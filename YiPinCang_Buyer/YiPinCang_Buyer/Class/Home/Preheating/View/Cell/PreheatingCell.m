//
//  PreheatingCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PreheatingCell.h"
#import "PhotoContainerView.h"

@implementation PreheatingCell
{
    UILabel *_titleL;
    PhotoContainerView *_photoView;
    UILabel *_timeL;
    UIButton *_goodBtn;
    UILabel *_goodL;
    UIImageView *_commentImgV;
    UILabel *_commentL;
    UIView *_bottomGrayV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup
{
    _titleL = [UILabel new];
    _titleL.font = LightFont(15);
    _titleL.textColor = [UIColor blackColor];
    _titleL.numberOfLines = 0;
    
    _photoView = [PhotoContainerView new];
    _photoView.containerType = PhotoContainerTypeFullScreenWidth;
    
    _timeL = [UILabel new];
    _timeL.font = LightFont(13);
    _timeL.textColor = [Color colorWithHex:@"#BFBFBF"];
    
    _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodBtn setImage:IMAGE(@"find_productdetails_icon_likes") forState:UIControlStateNormal];
    _goodBtn.adjustsImageWhenDisabled = NO;
    [_goodBtn addTarget:self action:@selector(goodBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    _goodL = [UILabel new];
    _goodL.font = LightFont(13);
    _goodL.textColor = [Color colorWithHex:@"#BFBFBF"];
    
    _commentImgV = [UIImageView new];
    _commentImgV.image = IMAGE(@"find_productdetails_icon_commentnumber");
    
    _commentL = [UILabel new];
    _commentL.font = LightFont(13);
    _commentL.textColor = [Color colorWithHex:@"#BFBFBF"];
    
    _bottomGrayV = [UIView new];
    _bottomGrayV.backgroundColor = [Color colorWithHex:@"#EBEBF1"];
    
    [self.contentView sd_addSubviews:@[_titleL, _photoView, _timeL, _goodBtn, _goodL, _commentImgV, _commentL, _bottomGrayV]];
    
    CGFloat margin = 14;
    
    _titleL.sd_layout
    .topSpaceToView(self.contentView, 7)
    .leftSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    _photoView.sd_layout
    .leftEqualToView(_titleL);
    
    _timeL.sd_layout
    .leftEqualToView(_photoView)
    .topSpaceToView(_photoView, 15)
    .widthIs(100)
    .autoHeightRatio(0);
    
    _commentL.sd_layout
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_photoView, 17)
    .heightIs(10);
    [_commentL setSingleLineAutoResizeWithMaxWidth:100];
    
    _commentImgV.sd_layout
    .rightSpaceToView(_commentL, 5)
    .topSpaceToView(_photoView, 10.5)
    .widthIs(25)
    .heightIs(25);
    
    _goodL.sd_layout
    .rightSpaceToView(_commentImgV, 29)
    .topSpaceToView(_photoView, 17)
    .heightIs(10);
    [_goodL setSingleLineAutoResizeWithMaxWidth:100];
    
    _goodBtn.sd_layout
    .rightSpaceToView(_goodL, 5)
    .topSpaceToView(_photoView, 10.5)
    .widthIs(25)
    .heightIs(25);
    
    _bottomGrayV.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_timeL, 15)
    .rightEqualToView(self.contentView)
    .heightIs(10);
}

- (void)setTempModel:(Pre_stracesModel *)tempModel
{
    _tempModel = tempModel;
    _titleL.text = _tempModel.strace_title;
    
    if (_tempModel.strace_content.count == 1) {
        _photoView.WH = _tempModel.aspect.floatValue;
    }
    _photoView.picPathStringsArray = _tempModel.strace_content;
    if (_tempModel.strace_content > 0) {
        _photoView.sd_layout.topSpaceToView(_titleL, 7);
    }else {
        _photoView.sd_layout.topSpaceToView(_titleL, 0);
    }
    _timeL.text = [YPC_Tools timeWithTimeIntervalString:_tempModel.strace_time Format:@"YYYY-MM-dd"];
    _goodL.text = _tempModel.strace_cool;
    _commentL.text = _tempModel.strace_comment;
    
    if ([_tempModel.islike isEqualToString:@"0"]) {
        [_goodBtn setImage:IMAGE(@"find_productdetails_icon_likes") forState:UIControlStateNormal];
        _goodBtn.enabled = YES;
    }else if ([_tempModel.islike isEqualToString:@"1"]) {
        [_goodBtn setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
        _goodBtn.enabled = NO;
    }
    
    [self setupAutoHeightWithBottomView:_bottomGrayV bottomMargin:0];
}

- (void)goodBtnClickAction
{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self]]) {
        [YPCNetworking postWithUrl:@"shop/explore/livegoodslike"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id" : self.tempModel.strace_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [_goodBtn setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
                                   _goodBtn.enabled = NO;
                                   [_tempModel setStrace_cool:[NSString stringWithFormat:@"%ld", _tempModel.strace_cool.integerValue + 1]];
                                   [_tempModel setIslike:@"1"];
                                   _goodL.text = _tempModel.strace_cool;
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
}

@end

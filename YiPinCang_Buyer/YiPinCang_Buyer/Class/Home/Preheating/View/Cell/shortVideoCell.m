//
//  shortVideoCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "shortVideoCell.h"

@interface shortVideoCell ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoImgH;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UIImageView *videoImgV;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) IBOutlet UILabel *goodL;
@property (strong, nonatomic) IBOutlet UILabel *commentL;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *zanBtn;

@end

@implementation shortVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.videoImgH.constant = ScreenWidth > 320 ? 170 : 150;
    [self layoutIfNeeded];
}

- (void)setTempModel:(Pre_stracesModel *)tempModel
{
    _tempModel = tempModel;
    _titleL.text = _tempModel.strace_title;
    [self.videoImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.video_img] placeholderImage:IMAGE(@"yure_zhanweitu2")];
    _timeL.text = [YPC_Tools timeWithTimeIntervalString:_tempModel.strace_time Format:@"YYYY-MM-dd"];
    _goodL.text = _tempModel.strace_cool;
    _commentL.text = _tempModel.strace_comment;
    
    if ([_tempModel.islike isEqualToString:@"0"]) {
        [self.zanBtn setImage:IMAGE(@"find_productdetails_icon_likes") forState:UIControlStateNormal];
        self.zanBtn.enabled = YES;
    }else if ([_tempModel.islike isEqualToString:@"1"]) {
        [self.zanBtn setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
        self.zanBtn.enabled = NO;
    }
}

- (IBAction)cellBtnClick:(UIButton *)sender {
    if ([sender isEqual:self.playBtn]) {
        self.ButtonClickedBlock(@"play");
    }
}

- (IBAction)zanClickAction:(UIButton *)sender {
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
        [YPCNetworking postWithUrl:@"shop/explore/livegoodslike"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id" : self.tempModel.strace_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [weakSelf.zanBtn setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
                                   weakSelf.zanBtn.enabled = NO;
                                   [_tempModel setStrace_cool:[NSString stringWithFormat:@"%ld", _tempModel.strace_cool.integerValue + 1]];
                                   [_tempModel setIslike:@"1"];
                                   _goodL.text = _tempModel.strace_cool;
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MyCommentCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/18.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "MyCommentCell.h"
#import "LiveDetailHHHVC.h"
@interface MyCommentCell ()
@property (strong, nonatomic) IBOutlet UIImageView *avatarImgV;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *goodImgV;

@end

@implementation MyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTempModel:(MyCommentModel *)tempModel
{
    _tempModel = tempModel;
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:tempModel.scomm_memberavatar] placeholderImage:IMAGE(@"mine_avatar_zhanweitu_img")];
    self.nameLbl.text = tempModel.scomm_membername;
    self.contentLbl.text = tempModel.scomm_content;
    self.timeLbl.text = tempModel.scomm_time;
    [self.goodImgV sd_setImageWithURL:[NSURL URLWithString:tempModel.strace_content_thumb] placeholderImage:YPCImagePlaceHolderSquare];
}
- (IBAction)pushLiveGroupDetail:(UIButton *)sender {
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    live.store_id = self.tempModel.store_id;
    [[YPC_Tools getControllerWithView:self].navigationController pushViewController:live animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  AccountMangerCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/7.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AccountMangerCell.h"

@interface AccountMangerCell ()
@property (strong, nonatomic) IBOutlet UIImageView *avatarImg;
@property (strong, nonatomic) IBOutlet UILabel *infoLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation AccountMangerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

- (void)setTempStr:(NSString *)tempStr
{
    self.titleLab.text = tempStr;
    if (self.indexPath.section == 0 && self.indexPath.row == 0) { // 头像
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:[YPCRequestCenter shareInstance].model.member_avatar] placeholderImage:IMAGE(@"mine_img_avatar")];
    }else if (self.indexPath.section == 0 && self.indexPath.row == 1) { // 昵称
        self.infoLab.text = [YPCRequestCenter shareInstance].model.member_truename;
    }else if (self.indexPath.section == 0 && self.indexPath.row == 2) { //性别
        NSInteger sexInteger = [YPCRequestCenter shareInstance].model.member_sex.integerValue;
        switch (sexInteger) {
            case 1:
                self.infoLab.text = @"男";
                break;
            case 2:
                self.infoLab.text = @"女";
                break;
            case 3:
                self.infoLab.text = @"未知";
                break;
                
            default:
                break;
        }
    }else if (self.indexPath.section == 0 && self.indexPath.row == 3) { // 出生日期
        self.infoLab.text = [YPCRequestCenter shareInstance].model.member_birthday;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

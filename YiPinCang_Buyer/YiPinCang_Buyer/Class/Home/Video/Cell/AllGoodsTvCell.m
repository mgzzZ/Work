//
//  IssueGoodsTvCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AllGoodsTvCell.h"
@interface AllGoodsTvCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *numWidthConstraint;
@property (strong, nonatomic) IBOutlet UILabel *numberL;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *priceL;
@property (strong, nonatomic) IBOutlet UILabel *commendNumL;
@property (strong, nonatomic) IBOutlet UILabel *commentNumL;

@end

@implementation AllGoodsTvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTempModel:(AllGoodsModel *)tempModel
{
    _tempModel = tempModel;
    
    self.numberL.text = @"34";
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.titleL.text = _tempModel.goods_name;
    self.priceL.text = [NSString stringWithFormat:@"¥%@", _tempModel.goods_price];
    self.commendNumL.text = _tempModel.strace_cool;
    self.commentNumL.text = _tempModel.strace_comment;
}

- (IBAction)buttonClickAction:(UIButton *)sender {
    self.ButtonClickedBlock(@"joinShopCar");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

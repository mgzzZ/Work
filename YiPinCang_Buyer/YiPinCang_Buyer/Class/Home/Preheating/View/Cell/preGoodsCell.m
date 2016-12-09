//
//  preGoodsCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "preGoodsCell.h"

@interface preGoodsCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation preGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setTempModel:(PreheatingGoodsModel *)tempModel
{
    _tempModel = tempModel;
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.titleL.text = [NSString stringWithFormat:@"　　　%@", _tempModel.goods_name];
    self.priceL.text = [NSString stringWithFormat:@"¥%@", _tempModel.goods_price];
}

- (IBAction)buyBtnClickAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

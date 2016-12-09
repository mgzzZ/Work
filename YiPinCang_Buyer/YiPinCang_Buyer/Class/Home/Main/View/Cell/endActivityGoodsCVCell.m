//
//  endActivityGoodsCVCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/26.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "endActivityGoodsCVCell.h"

@interface endActivityGoodsCVCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation endActivityGoodsCVCell

- (void)setTempModel:(CommendModel *)tempModel
{
    _tempModel = tempModel;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.priceL.text = [NSString stringWithFormat:@"¥ %@", _tempModel.goods_price];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

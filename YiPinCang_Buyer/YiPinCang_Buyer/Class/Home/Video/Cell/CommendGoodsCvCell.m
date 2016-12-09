//
//  CommendGoodsCvCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "CommendGoodsCvCell.h"
@interface CommendGoodsCvCell ()
@property (strong, nonatomic) IBOutlet UIImageView *ImgV;
@property (strong, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation CommendGoodsCvCell

- (void)setTempModel:(CommendModel *)tempModel
{
    _tempModel = tempModel;
    [self.ImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.priceL.text = [NSString stringWithFormat:@"￥%@", _tempModel.goods_price];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

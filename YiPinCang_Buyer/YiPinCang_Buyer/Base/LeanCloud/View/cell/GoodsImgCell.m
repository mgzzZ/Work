//
//  GoodsImgCell.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/20.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "GoodsImgCell.h"

@interface GoodsImgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (strong, nonatomic) IBOutlet UILabel *priceL;
@end

@implementation GoodsImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTempModel:(GoodsModel *)tempModel
{
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:tempModel.goods_image] placeholderImage:YPCImagePlaceHolder];
    self.priceL.text = [NSString stringWithFormat:@"¥%@", tempModel.goods_price];
}


@end

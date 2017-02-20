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
@property (nonatomic, strong) IBOutlet UILabel *priceL;
@property (strong, nonatomic) IBOutlet UILabel *originalpriceL;

@end

@implementation endActivityGoodsCVCell

- (void)setTempModel:(CommendModel *)tempModel
{
    _tempModel = tempModel;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.goods_image] placeholderImage:YPCImagePlaceHolderSquare];
    self.priceL.text = [NSString stringWithFormat:@"¥ %@", _tempModel.goods_price];

    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_tempModel.goods_marketprice attributes:attribtDic];
    self.originalpriceL.attributedText = attribtStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end

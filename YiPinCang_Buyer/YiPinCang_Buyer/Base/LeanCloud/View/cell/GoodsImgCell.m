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
@end

@implementation GoodsImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTempStr:(NSString *)tempStr
{
    if (_tempStr != tempStr) {
        _tempStr = tempStr;
    }
    
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_tempStr] placeholderImage:YPCImagePlaceHolder];
}


@end

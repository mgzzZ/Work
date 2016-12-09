//
//  AudienceCvCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AudienceCvCell.h"

@implementation AudienceCvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:YPCImagePlaceHolder];
}

@end

//
//  ChooseSizeCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ChooseSizeCell.h"

@interface ChooseSizeCell ()

@property (nonatomic,strong)NSIndexPath *oldIndex;

@end

@implementation ChooseSizeCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.titleLab = [[UILabel alloc]init];
        [self.bgView addSubview:self.titleLab];
        self.titleLab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (void)setIndex:(NSIndexPath *)index{
    if ([index isEqual:self.oldIndex]) {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.titleLab.textColor = [UIColor blackColor];
        self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        self.oldIndex = nil;
        if (self.error) {
            self.error(index);
        }
    }else{
        self.bgView.backgroundColor = [UIColor redColor];
        self.titleLab.textColor = [UIColor whiteColor];
        self.bgView.layer.borderColor = [UIColor redColor].CGColor;
        self.oldIndex = index;
        if (self.success) {
            self.success(index);
        }
    }
    
}
@end

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
        self.oldIndex = nil;
    
    }
    return self;
}

- (void)setIndex:(NSIndexPath *)index{
    if ([index isEqual:self.oldIndex]) {
        if (self.segcount == SEGCOUNTOFONECELL) {
            self.bgView.backgroundColor = [UIColor whiteColor];
            self.titleLab.textColor = [UIColor blackColor];
            self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        }
        self.oldIndex = nil;
        if (self.error) {
            self.error(index);
        }
    }else{
        if (self.segcount == SEGCOUNTOFONECELL) {
            self.bgView.backgroundColor = [UIColor redColor];
            self.titleLab.textColor = [UIColor whiteColor];
            self.bgView.layer.borderColor = [UIColor redColor].CGColor;
        }
        self.oldIndex = index;
        if (self.success) {
            self.success(index);
        }
    }
    
}

- (void)setModel:(Choose_spModel *)model{

    self.titleLab.text = [NSString stringWithFormat:@"%@",model.sp_value_name];
    self.bgView.layer.borderWidth = 2;
    // 0 或者没有 是可点
    // 1 已点击
    // 2 不可点击
    if (model.spType.length == 0 || [model.spType isEqualToString:@"0"]) {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.titleLab.textColor = [UIColor blackColor];
        self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    }else if ([model.spType isEqualToString:@"1"]){
        self.bgView.backgroundColor = [UIColor redColor];
        self.titleLab.textColor = [UIColor whiteColor];
        self.bgView.layer.borderColor = [UIColor redColor].CGColor;
    }else if([model.spType isEqualToString:@"2"]){
        self.titleLab.textColor = [Color colorWithHex:@"0xdbdbdb"];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    }else{
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.titleLab.textColor = [UIColor blackColor];
        self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    }
}

- (void)setSelected:(BOOL)selected
{
    
    if (self.segcount == SEGCOUNTMORECELL) {
        [super setSelected:selected];
        if (selected) {
//            self.bgView.backgroundColor = [UIColor redColor];
//            self.titleLab.textColor = [UIColor whiteColor];
//            self.bgView.layer.borderColor = [UIColor redColor].CGColor;
        }else{
//            self.bgView.backgroundColor = [UIColor whiteColor];
//            self.titleLab.textColor = [UIColor blackColor];
//            self.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        }
    }
}

@end

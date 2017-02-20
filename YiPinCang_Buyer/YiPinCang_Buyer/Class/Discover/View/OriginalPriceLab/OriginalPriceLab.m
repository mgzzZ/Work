//
//  OriginalPriceLab.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/28.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OriginalPriceLab.h"

@interface OriginalPriceLab ()

@property (nonatomic,strong)UIView *lineView;
@end

@implementation OriginalPriceLab

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineColor = [Color colorWithHex:@"#bfbfbf"];
        self.lineView_Y = 7.5;
    }
    return self;
}

- (void)setLineView_Y:(CGFloat)lineView_Y{
    if (_lineView_Y != lineView_Y) {
        _lineView_Y = lineView_Y;
    }
}

- (void)setWidth:(CGFloat)width{
    self.lineView.frame = CGRectMake(0, self.lineView_Y, width, 1);
    
}

- (void)setHeight:(CGFloat)height{
    [super setHeight: height];
    self.lineView_Y = height / 2.0;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
    }
    return _lineView;
}


- (void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
    }
    self.lineView.backgroundColor = _lineColor;
}


@end

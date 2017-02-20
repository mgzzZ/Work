//
//  GradientView.m
//  RACExercise
//
//  Created by YPC on 16/12/23.
//  Copyright © 2016年 mgzzZ. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *gradientView;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)CAShapeLayer *maskLayer;
@end

@implementation GradientView


- (instancetype)init{
    self = [super init];
    if (self) {
        self.bgColor = [UIColor clearColor];
        self.fillColor = [UIColor whiteColor];
        self.fromColor = [UIColor whiteColor];
        self.toColor = [UIColor whiteColor];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgColor = [UIColor whiteColor];
        self.fillColor = [UIColor whiteColor];
        self.fromColor = [UIColor whiteColor];
        self.toColor = [UIColor whiteColor];
   
    }
    return self;
}
- (void)setGradientWidth:(CGFloat)gradientWidth{
    if (_gradientWidth != gradientWidth) {
        _gradientWidth = gradientWidth;
        
    }
    [self addSubview:self.gradientView];
}


- (void)setFillColor:(UIColor *)fillColor{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
    }
}

- (void)setFromColor:(UIColor *)fromColor{
    if (_fromColor != fromColor) {
        _fromColor = fromColor;
    }
}

- (void)setToColor:(UIColor *)toColor{
    if (_toColor != toColor) {
        _toColor = toColor;
    }
}

- (void)setWidth:(CGFloat)width{
    if (_maxWidth != width) {
        _maxWidth = width;
    }
}

- (void)setHeight:(CGFloat)height{
    if (_maxHeight != height) {
        _maxHeight = height;
    }
    if (_bgView == nil) {
        [self addSubview:self.bgView];
        
    }
}



- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake(0, 0, self.maxWidth, self.maxHeight);
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = self.bgColor;
        _bgView.layer.borderColor = self.fillColor.CGColor;
        _bgView.layer.borderWidth = 1;
//        _bgView.layer.cornerRadius = self.maxHeight / 2;
    }
    return _bgView;
}

- (UIView *)gradientView{
    if (_gradientView == nil) {
        _gradientView = [[UIView alloc]init];
    }
    _gradientLayer = nil;
    _maskLayer = nil;
    _gradientView.frame = CGRectMake(0, 0, _gradientWidth, self.maxHeight);
    _gradientView.clipsToBounds = YES;
    [_gradientView.layer addSublayer:self.gradientLayer];
    if ((self.maxWidth - _gradientWidth) < (self.maxHeight / 2)) {
        _gradientView.layer.mask = self.maskLayer;
        _gradientView.layer.masksToBounds = YES;
    }else{
        _gradientView.layer.mask = self.maskLayer;
        _gradientView.layer.masksToBounds = YES;
    }
    return _gradientView;
}


- (CAShapeLayer *)maskLayer{
    if (_maskLayer == nil) {
        _maskLayer = [[CAShapeLayer alloc] init];
        if ((self.maxWidth - _gradientWidth) < (self.maxHeight / 2)) {
            UIBezierPath *maskPath =  [UIBezierPath bezierPathWithRoundedRect:_gradientView.bounds cornerRadius:0];
            _maskLayer.frame = CGRectMake(0, 0, _gradientWidth, self.maxHeight );
             _maskLayer.path = maskPath.CGPath;
        }else{
            UIBezierPath *maskPath =  [UIBezierPath bezierPathWithRoundedRect:_gradientView.bounds cornerRadius:0];
            _maskLayer.frame = CGRectMake(0, 0, _gradientWidth, self.maxHeight);
            _maskLayer.path = maskPath.CGPath;
        }
    }
    
    
    return _maskLayer;
}

- (CAGradientLayer *)gradientLayer{
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, _gradientWidth, self.maxHeight);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.colors = @[(__bridge id)self.fromColor.CGColor,
                                      (__bridge id)self.toColor.CGColor];
        _gradientLayer.locations = @[@(0.5f), @(1.0f)];
    }
    return _gradientLayer;
}

@end

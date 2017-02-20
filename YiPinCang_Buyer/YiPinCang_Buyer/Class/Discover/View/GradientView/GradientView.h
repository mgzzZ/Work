//
//  GradientView.h
//  RACExercise
//
//  Created by YPC on 16/12/23.
//  Copyright © 2016年 mgzzZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView


/**
 背景颜色
 */
@property (nonatomic,strong)UIColor *bgColor;



/**
 边框颜色
 */
@property (nonatomic,strong)UIColor *fillColor;


/**
 渐变颜色 -> 起始颜色
 */
@property (nonatomic,strong)UIColor *fromColor;


/**
 渐变颜色 -> 终止颜色
 */
@property (nonatomic,strong)UIColor *toColor;


/**
 渐变颜色宽度
 */
@property (nonatomic,assign)CGFloat gradientWidth;

/**
 渐变颜色最大宽度
 */
@property (nonatomic,assign)CGFloat maxWidth;

/**
 渐变颜色最大高度
 */
@property (nonatomic,assign)CGFloat maxHeight;

@end

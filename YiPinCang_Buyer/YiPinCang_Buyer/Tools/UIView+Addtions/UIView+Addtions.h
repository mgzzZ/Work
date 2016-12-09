//
//  UIView+Addtions.h
//  Cloud
//
//  Created by Mz on 14-7-12.
//  Copyright (c) 2014年 Mz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIView (Addtions)
@property(nonatomic)CGFloat x;
@property(nonatomic)CGFloat y;
@property(nonatomic)CGFloat centerx;
@property(nonatomic)CGFloat centery;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@property(nonatomic)CGPoint orign;
@property(nonatomic)CGSize size;
@property(nonatomic,readonly)CGFloat screeny;
@property(nonatomic,readonly)CGFloat screenx;   //屏幕宽
@property(nonatomic,readonly)CGRect screenRect;

@property (nonatomic, readonly)CGFloat maxX;
@property (nonatomic, readonly)CGFloat maxY;

// 移动左上角坐标
- (void)moveToPoint:(CGPoint)point;



- (void)removeAllSubviews;  //删除所有子视图
//根据imgv大小，算出image剪切大
- (CGRect)croppedImageSize:(UIImage *)image withImgv:(UIImageView *)imgv;
//计算文字大小
- (CGSize)stringSize:(CGSize)maxSize;
- (UIImage *)re_screenshot;
//根据两个color，返回渐进色图片
- (UIImage*) imageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType;
+ (UIImage *) createImageWithColor: (UIColor *) color;  //根据一个color转uiimage


@end

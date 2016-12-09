//
//  UIImage+helpers.h
//  what2
//
//  Created by Mz on 15/5/14.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (helpers)
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageCropWithRect:(CGRect)rect;
+ (UIImage *)gradientImageFromColors:(NSArray<UIColor *> *)colors withFrame:(CGRect)frame;
- (UIImage *)compressToScale:(CGFloat)scale;
- (UIImage *)compressTo:(NSInteger)MKMaxPushImage_KB;

- (CGSize)sizeToLimitSize:(CGSize)limitSize;
- (CGSize)sizeToLimitWidth:(CGFloat)limitWidth;
- (UIImage*)blurredImage;
@end

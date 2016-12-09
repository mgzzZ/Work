//
//  UIImage+helpers.m
//  what2
//
//  Created by Mz on 15/5/14.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import "UIImage+helpers.h"

@implementation UIImage (helpers)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageCropWithRect:(CGRect)rect
{
    rect.origin.x*=self.scale;
    rect.origin.y*=self.scale;
    rect.size.width*=self.scale;
    rect.size.height*=self.scale;
    
    if (rect.origin.x<0) {
        rect.origin.x = 0;
    }
    if (rect.origin.y<0) {
        rect.origin.y = 0;
    }
    
    //宽度高度过界就删去
    CGFloat cgWidth = CGImageGetWidth(self.CGImage);
    CGFloat cgHeight = CGImageGetHeight(self.CGImage);
    if (CGRectGetMaxX(rect)>cgWidth) {
        rect.size.width = cgWidth-rect.origin.x;
    }
    if (CGRectGetMaxY(rect)>cgHeight) {
        rect.size.height = cgHeight-rect.origin.y;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //修正回原scale和方向
    resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:self.scale orientation:self.imageOrientation];
    
    return resultImage;

}
+ (UIImage *)gradientImageFromColors:(NSArray<UIColor *> *)colors withFrame:(CGRect)frame
{
    NSMutableArray *willDrawCGColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [willDrawCGColors addObject:(id)obj.CGColor];
    }];
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)willDrawCGColors, NULL);
    CGPoint start = CGPointMake(frame.size.width * 0.5, 0);
    CGPoint end = CGPointMake(frame.size.width * 0.5, frame.size.height);
    //    start = CGPointMake(0.0, frame.size.height);
    //    end = CGPointMake(frame.size.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
//    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)compressToScale:(CGFloat)scale
{
    NSData *data = UIImageJPEGRepresentation(self, scale);
    return [UIImage imageWithData:data];
}
- (UIImage *)compressTo:(NSInteger)MKMaxPushImage_KB
{
    float maxFileSize = MKMaxPushImage_KB * 1024.0;
    float compression = 1.0f;
    //    [ExecutionTimeInterval beginTime:@"开始时间"];
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    NSData *imageData = [UIImage imageToWebP:image quality:compression];
    //    [ExecutionTimeInterval endTime:@"结束时间"];
    compression = maxFileSize / [imageData length];
    if (compression < 1) {
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    return [UIImage imageWithData:imageData];
}

// size
- (CGSize)sizeToLimitSize:(CGSize)limitSize
{
    CGSize returnSize = self.size;
    if (returnSize.width < returnSize.height)
    {
        return CGSizeMake(limitSize.height / returnSize.height * returnSize.width, limitSize.height);
    }else if (returnSize.width > returnSize.height) {
        return CGSizeMake(limitSize.width, limitSize.width / returnSize.width * returnSize.height);
    }
    return limitSize;
}
- (CGSize)sizeToLimitWidth:(CGFloat)limitWidth
{
    return CGSizeMake(limitWidth, limitWidth / self.size.width * self.size.height);
}
- (UIImage*)blurredImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

@end

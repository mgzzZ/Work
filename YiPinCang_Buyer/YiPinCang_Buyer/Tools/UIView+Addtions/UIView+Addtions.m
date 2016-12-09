//
//  UIView+Addtions.m
//  Cloud
//
//  Created by Mz on 14-7-12.
//  Copyright (c) 2014年 Mz. All rights reserved.
//

#import "UIView+Addtions.h"

@implementation UIView (Addtions)
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)maxX{
    return self.x + self.width;
}

- (CGFloat)maxY{
    return self.y + self.height;
}

- (CGFloat)centerx{
    return self.center.x;
}
- (void)setCenterx:(CGFloat)centerx{
    self.center = CGPointMake(centerx, self.center.y);
}
- (CGFloat)centery{
    return self.center.y;
}
- (void)setCentery:(CGFloat)centery{
    self.center = CGPointMake(self.center.x, centery);
}

- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}
- (CGPoint)orign{
    return self.frame.origin ;
}
- (void)setOrign:(CGPoint)orign{
    CGRect frame = self.frame;
	frame.origin = orign;
	self.frame = frame;
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}
- (CGFloat)screenx{
    return [UIScreen mainScreen].bounds.size.width;
}
- (CGFloat)screeny{
    return [UIScreen mainScreen].bounds.size.height;
}
- (CGRect)screenRect{
    return [UIScreen mainScreen].bounds;
}
- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (void)moveToPoint:(CGPoint)point{
    
    [self setX:point.x];
    [self setY:point.y];
    
}

- (UIImage *)re_screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//根据imgv大小，算出image剪切大
- (CGRect)croppedImageSize:(UIImage *)image withImgv:(UIImageView *)imgv{
    CGFloat intScal;
    CGRect rectPic = CGRectZero;
    if (image.size.width/imgv.width > image.size.height/imgv.height) {    //取比例小的一边结果
        intScal = image.size.height/imgv.height;
        rectPic.origin = CGPointMake((image.size.width - intScal*imgv.width)/2, 0);
    }else{
        intScal = image.size.width/imgv.width;
        rectPic.origin = CGPointMake(0, (image.size.height - intScal*imgv.height)/2);
    }
    
    rectPic.size = CGSizeMake(imgv.width * intScal  , imgv.height * intScal);
    return rectPic;
}
- (CGSize)stringSize:(CGSize)maxSize{
    UIFont *font = nil;
    NSString *text = nil;
    
    if ([self isKindOfClass:[UILabel class]]) {
        font = ((UILabel *)self).font;
        text = ((UILabel *)self).text;
    }else if([self isKindOfClass:[UIButton class]]){
        font = ((UIButton *)self).titleLabel.font;
        text = ((UIButton *)self).titleLabel.text;
    }else if([self isKindOfClass:[UITextView class]]){
        font = ((UITextView *)self).font;
        text = ((UITextView *)self).text;
    }
    CGSize size;
    
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                //                                [UIColor redColor], NSForegroundColorAttributeName,
                                //                                [UIColor yellowColor], NSBackgroundColorAttributeName,
                                nil];
        size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
    
    return size;
}
- (UIImage*) imageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end

//
//  UINavigationBar+BackgroundColor.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"

@implementation UINavigationBar (BackgroundColor)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mz_setBackgroundImage:(UIImage *)image
{
    if (!self.overlay) {
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [UIImage new];
    }
}

- (void)mz_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)mz_setBackgroundAlpha:(CGFloat)alpha
{
    self.overlay.alpha = alpha;
}

@end

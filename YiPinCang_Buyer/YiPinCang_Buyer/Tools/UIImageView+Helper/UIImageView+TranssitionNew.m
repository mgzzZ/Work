//
//  UIImageView+Helper.m
//  what2
//
//  Created by Mz on 15/9/1.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import "UIImageView+TranssitionNew.h"

@implementation UIImageView (TranssitionNew)
- (void)transsitionNewImage:(UIImage *)newImg
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.removedOnCompletion = YES;
    [self.layer addAnimation:transition forKey:@"transition"];
    self.image = newImg;
}
@end

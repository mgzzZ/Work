//
//  UIView+BadgeValue.m
//  YiPinCang_Buyer
//
//  Created by Apple on 15/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "UIView+BadgeValue.h"
#import <objc/runtime.h>

static char badgeValue_static;

static CGFloat badgeValue_height = 17;

@implementation UIView (BadgeValue)

- (void)setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &badgeValue_static, badgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (badgeValue == nil || [badgeValue isEqualToString:@""] || badgeValue.integerValue <= 0) {
        [self clearBadgeValue];
    }
    else{
        NSAssert([self isAllNumber:badgeValue], @"字符串内容必须是数字");
        CGRect rect = [badgeValue  boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont smallSystemFontSize]]} context:nil];
        // 创建红点
        UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect.size.width > badgeValue_height ? rect.size.width + 6 : badgeValue_height, badgeValue_height)];
        redBtn.center = CGPointMake(self.frame.size.width, 0);
        redBtn.tag = 451467999;
        redBtn.layer.cornerRadius = badgeValue_height / 2;
        redBtn.layer.masksToBounds = YES;
        redBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        
        redBtn.backgroundColor = [UIColor redColor];
        [redBtn setTitle:badgeValue forState:UIControlStateNormal];
        [self addSubview:redBtn];
    }
}

- (void)setWhiteLayerbadgeValue:(NSString *)WhiteLayerbadgeValue
{
    objc_setAssociatedObject(self, &badgeValue_static, WhiteLayerbadgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (WhiteLayerbadgeValue == nil || [WhiteLayerbadgeValue isEqualToString:@""] || WhiteLayerbadgeValue.integerValue <= 0) {
        [self clearBadgeValue];
    }
    else{
        NSAssert([self isAllNumber:WhiteLayerbadgeValue], @"字符串内容必须是数字");
        CGRect rect = [WhiteLayerbadgeValue  boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont smallSystemFontSize]]} context:nil];
        // 创建红点
        UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect.size.width > badgeValue_height ? rect.size.width + 6 : badgeValue_height, badgeValue_height)];
        redBtn.center = CGPointMake(self.frame.size.width, 0);
        redBtn.tag = 451467999;
        redBtn.layer.cornerRadius = badgeValue_height / 2;
        redBtn.layer.masksToBounds = YES;
        redBtn.layer.borderWidth = 1.f;
        redBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        redBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        
        redBtn.backgroundColor = [UIColor redColor];
        [redBtn setTitle:WhiteLayerbadgeValue forState:UIControlStateNormal];
        [self addSubview:redBtn];
    }
}

- (void)setLittleRedBadgeValue:(NSString *)littleRedBadgeValue
{
    objc_setAssociatedObject(self, &badgeValue_static, littleRedBadgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (littleRedBadgeValue == nil || [littleRedBadgeValue isEqualToString:@""] || (littleRedBadgeValue.integerValue <= 0 && ![littleRedBadgeValue isEqualToString:@"···"])) {
        [self clearBadgeValue];
    }else{
        //新建小红点
        UIButton *badgeView = [UIButton buttonWithType:UIButtonTypeCustom];
        badgeView.tag = 451467999;
        [badgeView setBackgroundColor:[UIColor redColor]];
        
        badgeView.frame = CGRectMake(0, 0, 8, 8);
        badgeView.center = CGPointMake(self.frame.size.width - 2, 4);
        badgeView.layer.cornerRadius = badgeView.frame.size.width / 2;
        
        [self addSubview:badgeView];
    }
}

- (NSString *)badgeValue{
    NSString *badgeValue = objc_getAssociatedObject(self, &badgeValue_static);
    // 少于0 重置为0
    if (badgeValue.integerValue < 0) {
        return @"0";
    }
    else{
        return badgeValue;
    }
}

- (NSString *)WhiteLayerbadgeValue{
    NSString *WhiteLayerbadgeValue = objc_getAssociatedObject(self, &badgeValue_static);
    // 少于0 重置为0
    if (WhiteLayerbadgeValue.integerValue < 0) {
        return @"0";
    }
    else{
        return WhiteLayerbadgeValue;
    }
}

- (NSString *)littleRedBadgeValue
{
    NSString *littleRedBadgeValue = objc_getAssociatedObject(self, &badgeValue_static);
    // 少于0 重置为0
    if (littleRedBadgeValue.integerValue < 0) {
        return @"0";
    }
    else{
        return littleRedBadgeValue;
    }
}

- (void)clearBadgeValue{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == 451467999) {
            [view removeFromSuperview];
        }
    }
}

// 判断是否全是数字
- (BOOL)isAllNumber:(NSString *)text{
    unichar str;
    for (NSInteger index = 0; index < text.length; index ++) {
        str = [text characterAtIndex:index];
        if (isdigit(str)) {
            return YES;
        }
    }
    return NO;
}

@end

//
//  OrderFooter.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderFooter.h"

@implementation OrderFooter
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.contentfootView.frame = self.bounds;
        [self addSubview:self.contentfootView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//+ (OrderFooter *)orderFooter{
//    OrderFooter *OrderFooter = [[NSBundle mainBundle] loadNibNamed:@"OrderFooter" owner:self options:nil][0];
//    
//    return OrderFooter;
//}
@end

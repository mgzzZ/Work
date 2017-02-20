//
//  LiveListHeaderView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "LiveListHeaderView.h"

@implementation LiveListHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}


@end

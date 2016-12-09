//
//  LoginsticsHeaderView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/30.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LoginsticsHeaderView.h"

@implementation LoginsticsHeaderView

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

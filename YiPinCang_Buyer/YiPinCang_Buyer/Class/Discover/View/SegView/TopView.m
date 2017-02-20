//
//  TopView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "TopView.h"

@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}
- (IBAction)btnClick:(UIButton *)sender {
    
    for (int i = 1000; i < 1004; i++) {
        UIButton *btn = (UIButton *)[self.contentView viewWithTag: i];
        if (i == 1000) {
            btn.selected = YES;
        }else if(i == 1001 && sender.tag == 1001){
        }else{
            btn.selected = NO;
        }
    }
    
    if (self.didBtnClick) {
        self.didBtnClick(sender,sender.tag);
    }
}

@end

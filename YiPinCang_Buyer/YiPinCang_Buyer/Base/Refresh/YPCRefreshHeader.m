//
//  YPCRefreshHeader.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/30.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "YPCRefreshHeader.h"

@implementation YPCRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"a%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<56; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"a%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:2.f forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:2.f forState:MJRefreshStateRefreshing];
    
}

@end

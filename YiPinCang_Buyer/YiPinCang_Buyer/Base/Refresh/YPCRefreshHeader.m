//
//  YPCRefreshHeader.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/30.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "YPCRefreshHeader.h"
@interface YPCRefreshHeader ()
@property (nonatomic, strong) UIImageView *logoImgV;
@property (nonatomic, strong) UILabel *stateL;
@property (nonatomic, strong) UIActivityIndicatorView *activityV;
@end

@implementation YPCRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.mj_h = 100;
    
//    self.bgImgV = [UIImageView new];
//    self.bgImgV.contentMode = UIViewContentModeScaleAspectFit;
//    self.bgImgV.clipsToBounds = YES;
//    self.bgImgV.image = IMAGE(@"refreshBgImg");
//    [self addSubview:self.bgImgV];
    
    self.logoImgV = [UIImageView new];
    self.logoImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImgV.image = IMAGE(@"refresh");
    [self addSubview:self.logoImgV];
    
    self.stateL = [UILabel new];
    self.stateL.textColor = [Color colorWithHex:@"#666666"];
    self.stateL.font = BoldFont(15);
    self.stateL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.stateL];
    
    self.activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.activityV];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.logoImgV.frame = CGRectMake(ScreenWidth / 2 - 50, -440.f, 100.f, 500.f);
    
    self.stateL.frame = CGRectMake(0, 70.f, ScreenWidth, 20.f);
    
    self.activityV.center = self.stateL.center;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.stateL.hidden = NO;
            [self.activityV stopAnimating];
            self.stateL.text = @"赶紧下拉吖";
            break;
        case MJRefreshStatePulling:
            [self.activityV stopAnimating];
            self.stateL.text = @"赶紧放开我吧";
            break;
        case MJRefreshStateRefreshing:
            self.stateL.hidden = YES;
            [self.activityV startAnimating];
            break;
        default:
            break;
    }
}

@end

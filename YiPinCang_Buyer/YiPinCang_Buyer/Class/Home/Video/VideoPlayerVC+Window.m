//
//  VideoPlayerVC+Window.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "VideoPlayerVC+Window.h"

@implementation VideoPlayerVC (Window)

- (void)playVideoOnWindow
{
    [self.playerV removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.playerV.transform = CGAffineTransformIdentity;
        self.playerV.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerV.topView.hidden = YES;
        self.playerV.bottomView.hidden = YES;
        [window addSubview:self.playerV];
    [UIView animateWithDuration:.2f animations:^{
        [self.playerV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(window.mas_right);
            make.bottom.equalTo(window.mas_bottom).offset(-70);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(160);
        }];
        [self.playerV.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.playerV.mas_right);
            make.top.equalTo(self.playerV.mas_top);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        [window layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        [window bringSubviewToFront:self.playerV];
        self.playerV.playerIsOnWindow = YES;
        self.playerV.isRemoveFromWindow = NO;
    }];
}

- (void)hiddenVideoOnWindowWithViewController:(UIViewController *)vc
{
    [self.playerV removeFromSuperview];
        self.playerV.transform = CGAffineTransformIdentity;
        self.playerV.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerV.topView.hidden = NO;
        self.playerV.bottomView.hidden = YES;
        [self.playerBgView addSubview:self.playerV];
    [UIView animateWithDuration:.2f animations:^{
        [self.playerV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.playerBgView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.playerV.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.playerV).offset(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self.playerV).with.offset(20);
        }];
        [self.view layoutIfNeeded];
        
        [self.navigationController popToViewController:vc animated:YES];
    }completion:^(BOOL finished) {
        [self.playerBgView bringSubviewToFront:self.playerV];
        self.playerV.playerIsOnWindow = NO;
        self.playerV.isRemoveFromWindow = NO;
    }];
}

- (void)removeVideoOnWindow
{
    [self.playerV pause];
    [self.playerV removeFromSuperview];
    self.playerV.transform = CGAffineTransformIdentity;
    self.playerV.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerV.topView.hidden = NO;
    self.playerV.bottomView.hidden = YES;
    [self.playerBgView addSubview:self.playerV];
    [self.playerV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerBgView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.playerV.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playerV).offset(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.playerV).with.offset(20);
    }];
    [self.view layoutIfNeeded];
    [self.playerBgView bringSubviewToFront:self.playerV];
    self.playerV.playerIsOnWindow = NO;
    self.playerV.isRemoveFromWindow = YES;
}


@end
